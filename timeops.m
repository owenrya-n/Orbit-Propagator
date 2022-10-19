function H = timeops(date)
date=datetime(date,'InputFormat','dd-MM-yyyy')
tu=(juliandate(date)-2451545)/36525
H0=24110.54841+8640184.812866*tu+0.093104*tu^2-6.2*10^-6*tu^3
w=1.00273790935+5.9*10^-11*tu
H=H0+w*(t-dt)