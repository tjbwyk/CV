#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/features/normal_3d.h>
#include <pcl/surface/gp3.h>
#include <pcl/io/vtk_io.h>
#include <pcl/surface/mls.h>

int main(int argc, char** argv) {	
	pcl::PCLPointCloud2 cloud_blob;
	
	// Read point cloud
	if (argc < 2) {
		PCL_ERROR("Please specify the PCD file.\n");
		return -1;
	} else {
		if (pcl::io::loadPCDFile(argv[1], cloud_blob) == -1) {
			PCL_ERROR("Couldn't read the file.\n");
			return -1;
		}
	}

//	std::cout << "loaded" << cloud->width * cloud->height
//		<< " data points from " << argv[1] << " with the following fields:"
//		<< std::endl;
//	for (size_t i = 0; i < cloud->points.size(); i++)
//		std::cout << " " << cloud->points[i].x
//			<< " " << cloud->points[i].y
//			<< " " << cloud->points[i].z
//			<< std::endl;

	// Transform the data into an appropriate type
	pcl::PointCloud<pcl::PointXYZ>::Ptr cloud_with_normals(new pcl::PointCloud<pcl::PointXYZ>);
	pcl::fromPCLPointCloud2(cloud_blob, *cloud_with_normals);	

	// Create a KD-Tree
	pcl::search::KdTree<pcl::PointXYZ>::Ptr tree1(new pcl::search::KdTree<pcl::PointXYZ>);

	// New PointNormal type with normals calculated by MLS
	pcl::PointCloud<pcl::PointNormal>::Ptr cloud_mls(new pcl::PointCloud<pcl::PointNormal>);
	
	// Init object (second point type is for the normals, even if unused)
	pcl::MovingLeastSquares<pcl::PointXYZ, pcl::PointNormal> mls;

	mls.setComputeNormals(true);

	// Set parameters
	mls.setInputCloud(cloud_with_normals);
	mls.setPolynomialFit(true);
	mls.setSearchMethod(tree1);
	mls.setSearchRadius(0.03);

	// Reconstruct
	mls.process(*cloud_mls);

	// Create search tree
	pcl::search::KdTree<pcl::PointNormal>::Ptr tree2(new pcl::search::KdTree<pcl::PointNormal>);
	tree2->setInputCloud(cloud_mls);
	
	// Initialize objects
	pcl::GreedyProjectionTriangulation<pcl::PointNormal> gp3;
	pcl::PolygonMesh triangles;

	// Set the maximum distance between connected points (maximum edge length)
	gp3.setSearchRadius(0.025);

	// Set typicla values for the parameters
	gp3.setMu(2.5);
	gp3.setMaximumNearestNeighbors(200);
	gp3.setMaximumSurfaceAngle(M_PI / 4); // 45 degrees
	gp3.setMinimumAngle(M_PI / 18); // 10 degrees
	gp3.setMaximumAngle(2 * M_PI / 3); // 120 degrees
	gp3.setNormalConsistency(false);
	
	// Get result
	gp3.setInputCloud(cloud_mls);
	gp3.setSearchMethod(tree2);
	gp3.reconstruct(triangles);

	// Additional vertex information
	std::vector<int> parts = gp3.getPartIDs();
	std::vector<int> states = gp3.getPointStates();

	// Save the result
	pcl::io::saveVTKFile("mesh_mls.vtk", triangles);

	// Finish
	return 0;
}
