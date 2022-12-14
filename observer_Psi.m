A=[0 0; 1 0];
B=[1/quad.Izz*quad.k;0];
C=[0 1];

poles = eig(A)

t = 0:0.01:2;
u = zeros(size(t));
x0 = [0.01 0];

sys = ss(A,B,C,0);

[y,t,x] = lsim(sys,u,t,x0);
plot(t,y)
title('Open-Loop Response to Non-Zero Initial Condition')
xlabel('Time (sec)')
ylabel('Ball Position (m)')

----------------

%p1 = -10 + 10i;
%p2 = -10 - 10i;

%K = place(A,B,[p1 p2]);
%sys_cl = ss(A-B*K,B,C,0);

%lsim(sys_cl,u,t,x0);
%xlabel('Time (sec)')
%ylabel('Ball Position (m)')

----------------

p1 = -20 + 0.01i;
p2 = -20 - 0.01i;

K = place(A,B,[p1 p2]);
sys_cl = ss(A-B*K,B,C,0);

lsim(sys_cl,u,t,x0);
xlabel('Time (sec)')
ylabel('Ball Position (m)')

Introducing the Reference Input

-------------------

t = 0:0.01:2;
u = 0.001*ones(size(t));

sys_cl = ss(A-B*K,B,C,0);

lsim(sys_cl,u,t);
xlabel('Time (sec)')
ylabel('Ball Position (m)')
axis([0 2 -4E-6 0])


Nbar = rscale(sys,K)


lsim(sys_cl,Nbar*u,t)
title('Linear Simulation Results (with Nbar)')
xlabel('Time (sec)')
ylabel('Ball Position (m)')
axis([0 2 0 1.2*10^-3])


Observer Design

---------------

op1 = -100;
op2 = -101;


L = place(A',C',[op1 op2])';


At = [ A-B*K             B*K
       zeros(size(A))    A-L*C ];

Bt = [    B*Nbar
       zeros(size(B)) ];

Ct = [ C    zeros(size(C)) ];


sys = ss(At,Bt,Ct,0);
lsim(sys,zeros(size(t)),t,[x0 x0]);
title('Linear Simulation Results (with observer)')
xlabel('Time (sec)')
ylabel('Ball Position (m)')


t = 0:1E-6:0.1;
x0 = [1 0.5];
[y,t,x] = lsim(sys,zeros(size(t)),t,[x0 x0]);

n = 2;
e = x(:,n+1:end);
x = x(:,1:n);
x_est = x - e;

% Save state variables explicitly to aid in plotting
h = x(:,1); h_dot = x(:,2);
h_est = x_est(:,1); h_dot_est = x_est(:,2);

plot(t,h,'-r',t,h_est,':r',t,h_dot,'-b',t,h_dot_est,':b')
xlabel('Time (sec)')