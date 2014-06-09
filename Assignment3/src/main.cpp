#include <iostream>
#include <pcl/io/pcd_io.h>
#include <pcl/point_types.h>
#include <pcl/kdtree/kdtree_flann.h>
#include <pcl/io/vtk_io.h>
#include <pcl/surface/poisson.h>

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

	// Init Poisson object
	pcl::Poisson<pcl::PointNormal> poisson;
	poisson.setInputCloud(cloud_with_normals);

	// Get result
	pcl::PolygonMesh triangles;
	poisson.performReconstruction(triangles);

	// Save triangulation result
	pcl::io::saveVTKFile("mesh.vtk", triangles);

	// Finish
	return 0;
}
