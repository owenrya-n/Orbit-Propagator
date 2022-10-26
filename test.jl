
using FileIO, Colors, GeometryBasics

using AbstractPlotting

earth = load("earthImage.Jpg")
m = uv_mesh(Tesselation(Sphere(Point3f0(0), 1f0), 60))
mesh(m, color=earth, shading = false)
