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
fmdate=DateTime(2022,12,05,3)
epocht=datetime2julian(fmdate)
gdate=DateTime(2025,2,10,4)
e2date=datetime2julian(gdate)



#Establish Orbital Elements
a0=7235000 #semimajor axis in m
e0=0#eccentricity
i0=1.34#initial inclination in radians
Ω0=3.65#Right Ascension of the Ascending Node
ω0=0;#Argument of Perigree
f0=0;#true anomaly

ince=1;#increment in days
dt=e2date-epocht


#Begin Orbit Propagation
#eop_IAU2000A = get_iers_eop(Val(:IAU2000A)); 
#orbit = init_orbit_propagator(Val(:J2), KeplerianElements(7235000, 0, 0.01, 3.65, 0, 0.0, 0.0));
#orbit = init_orbit_propagator(Val(:J2),0,7235000, 0, 1.34, 3.65, 0, 0.0, 0.0);
orbit= init_orbit_propagator(Val(:J2), epocht, a0, e0, i0, Ω0, ω0, f0);
stl=collect(1:ince:dt)
r, v = propagate!(orbit, stl*60*60*24);
#deltat=datetime2unix(gdate)-datetime2unix(fmdate);
#timeinsec=1:ince:dt
#r,v=propagate!(orbit,timeinsec)
ptp=zeros(3,length(stl));#initialize output array
ptq=zeros(3,length(stl));
#convert tuple to matrix
for i in 1:length(stl)
    ptp[:,i]=r[i,1];
    i=i+1;
end
#write to csv
CSV.write("plots.csv", DataFrame(ptp, :auto),
                      header = false)   


for j in 1:length(stl)
    ptn=ecef_to_geodetic([ptp[1,j],ptp[2,j],ptp[3,j]])
    ptq[:,j].=ptn
    j=j+1;
end


#plot
img = load("earth2Dmap.png");
plot(img)
plot!(200*ptq[2,25:145].+500,200*ptq[1,25:145].+500)
savefig("2d.png")

anim = @animate for i ∈ 100:length(stl)
    plot3d(img)
    plot3d!(ptp[1,i-50:i],ptp[2,i-50:i],ptp[3,i-50:i],title="J4 Orbit Pertubations")
end
gif(anim, "anim_fps15.gif", fps = 15)

plot3d(ptp[1,:],ptp[2,:],ptp[3,:],title="J4 Orbit Pertubations")
savefig("3d.png")
                   