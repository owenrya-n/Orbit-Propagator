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
gdate=DateTime(2022,12,25,4)
e2date=datetime2julian(fmdate)



#Establish Orbital Elements
a0=7235000 #semimajor axis in m
e0=0#eccentricity
i0=1.34#initial inclination
Ω0=3.65#Right Ascension of the Ascending Node
ω0=0;#Argument of Perigree
f0=0;#true anomaly

ince=12;#increment



#Begin Orbit Propagation
#eop_IAU2000A = get_iers_eop(Val(:IAU2000A)); 
#orbit = init_orbit_propagator(Val(:J2), KeplerianElements(7235000, 0, 0.01, 3.65, 0, 0.0, 0.0));
#orbit = init_orbit_propagator(Val(:J2),0,7235000, 0, 1.34, 3.65, 0, 0.0, 0.0);
orbit= init_orbit_propagator(Val(:J2), epocht, a0, e0, i0, Ω0, ω0, f0);

r, v = propagate!(orbit, collect(1:ince:1000)*60*60);
deltat=datetime2unix(gdate)-datetime2unix(fmdate);
timeinsec=1:ince:deltat
#r,v=propagate!(orbit,timeinsec)
ptp=zeros(3,length(timeinsec));#initialize output array

#convert tuple to matrix
for i in 1:9
    ptp[:,i]=r[i,1];
    i=i+1;
end

#write to csv
CSV.write("test.csv", DataFrame(ptp, :auto),
                      header = false)   


#plot
img = load("rect.jpg")
plot3d(ptp[1,:],ptp[2,:],ptp[3,:])


                   