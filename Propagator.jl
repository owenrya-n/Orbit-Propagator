# Keplerian Orbit Visualizer #
# Created 10/18/2022         #
# Owen Ryan and Oli Szavuj   #

#uses satellite toolbox
using Dates
using SatelliteToolbox
using PlotlyJS
using LinearAlgebra
using CSV, DataFrames

#Format Date Times
fmdate=DateTime(2022,12,05,3)
epocht=datetime2julian(fmdate)
gdate=DateTime(2023,02,19,2)
e2date=datetime2julian(fmdate)

#Establish Orbital Elements
a0=7235 #semimajor axis in km
e0=0#eccentricity
i0=-77.6#initial inclination
Ω0=3.65#Right Ascension of the Ascending Node
ω0=0;#Argument of Perigree
f0=0;#true anomaly
ince=3000;#increment
ptp=zeros(3,length(timeinsec));#initialize output array


#Begin Orbit Propagation
eop_IAU2000A = get_iers_eop(Val(:IAU2000A)); 
orbit= init_orbit_propagator(Val(:J2), epocht, a0, e0, i0, Ω0, ω0, f0);
deltat=datetime2unix(gdate)-datetime2unix(fmdate);
timeinsec=1:ince:deltat
r,v=propagate!(orbit,timeinsec)

#convert tuple to matrix
for i in 1:length(timeinsec)-2
    ptp[:,i]=r[i,1];
    i=i+1;
end

#write to csv
CSV.write("test.csv", DataFrame(ptp, :auto),
                         header = false)   
                   