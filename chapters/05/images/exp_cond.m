clear all;
close all;
sim_time = 50; %s
dt = 0.0002;
T = 0:dt:sim_time; % 1 second simulation
Vm = zeros(sim_time/dt + 1, 1);
E_L = -60; %mV
Vm(1) = E_L; %mV
g_L = 0.01; %uS
C = 1; %nF
V_th = -40; %mV
V_R = -70;

s = zeros(sim_time/dt + 1, 1);

g_syn = zeros(sim_time/dt + 1, 1);
g_syn(1) = 0.008;
E = -80;
tau_syn = 20;

for t = 1:length(T) - 1,
    if t == 15000,
        s(t) = 37.5;
    elseif t > 12000 & t< 200000 & mod(t, 20000) == 0,
        s(t) = 100;
    elseif t > 200000 & mod(t, 20000) == 0,
        s(t) = 5;
    end
end


for t=1:length(T)-1,
    if Vm(t) >= V_th,
        g_syn(t+1) = g_syn(t) + dt * (-g_syn(t)/tau_syn*(Vm(t) - E));

        Vm(t+1) = V_R;

    else,
      g_syn(t+1) = g_syn(t) - 0.00000000001;
      Vm(t+1) = Vm(t) + dt * (g_L*(E_L-Vm(t)) + s(t)*1000)/C;
    end;

end;

T = T;

subplot(2,1,1);
plot(T,Vm,'LineWidth', 3.0);

yline(V_th);
xlabel('Time [s]', 'FontSize',20);

ylabel('Voltage [mV]','FontSize',20 );

subplot(2,1,2);
plot(T, g_syn, 'r', 'LineWidth', 3.0);

xlabel('Time [s]', 'FontSize',20);

ylabel('g [S]', 'FontSize',20);

grid on;


% Parameters from https://www.cns.nyu.edu/~david/handouts/integrate-and-fire.pdf
