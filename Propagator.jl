# Keplerian Orbit Visualizer #
# Created 10/18/2022         #
# Owen Ryan and Oli Szavuj   #

#uses satellite toolbox
using Dates
using SatelliteToolbox
using Plots, Images
using LinearAlgebra
using CSV, DataFrames

#Format Date Times
fmdate=DateTime(2022,12,05,1)
epocht=datetime2julian(fmdate)
gdate=DateTime(2023,8,20,1)
#gdate=DateTime(2023,1,19,5)
e2date=datetime2julian(gdate)
img = load("scs.jpg");


#Establish Orbital Elements
a0=7235000 #semimajor axis in m
e0=0#eccentricity
i0=1.34#initial inclination in radians
Ω0=3.65#Right Ascension of the Ascending Node 3.65
ω0=0;#Argument of Perigree
f0=0;#true anomaly


radius=6371000
n = 100

q=23
ince=.5;#increment in days
dt=e2date-epocht


#Begin Orbit Propagation
orbit= init_orbit_propagator(Val(:J4), epocht, a0, e0, i0, Ω0, ω0, f0);
stl=collect(1:ince:dt)
r, v = propagate!(orbit, stl*60*60*24);
u = range(-π, π; length = n)
v = range(0, π; length = n)
x = radius*cos.(u) * sin.(v)'
y = radius*sin.(u) * sin.(v)'
z = radius*ones(n) * cos.(v)'
ptp=zeros(3,length(stl));#initialize output array
ptq=zeros(3,length(stl));
xx=(0,1000);


#convert tuple to matrix
for i in 1:length(stl)
    ptp[:,i]=r[i,1];
    i=i+1;
end

for j in 1:length(stl)
    ptn=ecef_to_geodetic([ptp[1,j],ptp[2,j],ptp[3,j]])
    ptq[:,j].=ptn
    j=j+1;
end

#write to csv
CSV.write("plots.csv", DataFrame(ptp, :auto),
                      header = false)   




#plot
plot!(img)
for b::Int in 3:length(stl)/q-2
        plot!(1000/pi*ptq[2,(b*q):(b*q+q+11)].+500,1000/pi*ptq[1,(b*q):(b*q+q+11)].+500,xlims=xx,ylims=xx,linecolor=:red,legend=false)
end
savefig("fearth.png")


anim = @animate for i ∈ 100:length(stl)
    surface(x, y, z, color=:ocean)
    plot3d!(ptp[1,i-30:i],ptp[2,i-30:i],ptp[3,i-30:i],title="Orbit under J2-J4 effects, drag",color=:red,colorbar=false,legend=false)
    
end
gif(anim, "anim_fps15.gif", fps = 15)


surface(x, y, z, color=:ocean)
plot3d!(ptp[1,:],ptp[2,:],ptp[3,:],title="Orbit under J2-J4 effects, drag",color=:purple,legend=false,colorbar=false)
savefig("3d.png")


                   