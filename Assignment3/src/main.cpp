#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/features/normal_3d.h>
#include <pcl/surface/gp3.h>
#include <pcl/io/vtk_io.h>

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
	pcl::PointCloud<pcl::PointNormal>::Ptr cloud_with_normals(new pcl::PointCloud<pcl::PointNormal>);
	pcl::fromPCLPointCloud2(cloud_blob, *cloud_with_normals);	

	// Create search tree
	pcl::search::KdTree<pcl::PointNormal>::Ptr tree(new pcl::search::KdTree<pcl::PointNormal>);
	tree->setInputCloud(cloud_with_normals);
	
	// Initialize objects
	pcl::GreedyProjectionTriangulation<pcl::PointNormal> gp3;
	pcl::PolygonMesh triangles;

	// Set the maximum distance between connected points (maximum edge length)
	gp3.setSearchRadius(0.025);

	// Set typicla values for the parameters
	gp3.setMu(2.5);
	gp3.setMaximumNearestNeighbors(150);
	gp3.setMaximumSurfaceAngle(M_PI / 4); // 45 degrees
	gp3.setMinimumAngle(M_PI / 18); // 10 degrees
	gp3.setMaximumAngle(2 * M_PI / 3); // 120 degrees
	gp3.setNormalConsistency(false);
	
	// Get result
	gp3.setInputCloud(cloud_with_normals);
	gp3.setSearchMethod(tree);
	gp3.reconstruct(triangles);

	// Additional vertex information
	std::vector<int> parts = gp3.getPartIDs();
	std::vector<int> states = gp3.getPointStates();

	// Save the result
	pcl::io::saveVTKFile("mesh.vtk", triangles);

	// Finish
	return 0;
}
