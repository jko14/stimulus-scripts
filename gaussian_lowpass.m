function next = gaussian_lowpass(curr,tau,dt)

% returns next sample, given an exponential tau and a dt for the update
% rate, and teh current value... std of 1!

next = curr.*(1-dt/tau) + randn(size(curr))*sqrt(2*dt/tau);