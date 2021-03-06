function [ dx ] = systemTemp(t, x)
	dx = zeros(42, 1);
	dx(1) = x(2);
	dx(2) = x(3);
	dx(3) = 1/2*(sqrt(0.0000001+(x(6)+1)^2)-sqrt(0.0000001+(x(6)-1)^2));
	dx(4) = 0;
	dx(5) = -x(4);
	dx(6) = -x(5);
	dx(7) = x(8);
	dx(8) = x(9);
	dx(9) = -x(12)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(10) = 0;
	dx(11) = -x(10);
	dx(12) = -x(11);
	dx(13) = x(14);
	dx(14) = x(15);
	dx(15) = -x(18)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(16) = 0;
	dx(17) = -x(16);
	dx(18) = -x(17);
	dx(19) = x(20);
	dx(20) = x(21);
	dx(21) = -x(24)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(22) = 0;
	dx(23) = -x(22);
	dx(24) = -x(23);
	dx(25) = x(26);
	dx(26) = x(27);
	dx(27) = -x(30)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(28) = 0;
	dx(29) = -x(28);
	dx(30) = -x(29);
	dx(31) = x(32);
	dx(32) = x(33);
	dx(33) = -x(36)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(34) = 0;
	dx(35) = -x(34);
	dx(36) = -x(35);
	dx(37) = x(38);
	dx(38) = x(39);
	dx(39) = -x(42)*((2*x(6) - 2.0)/(4*((x(6) - 1)^2 + 0.0000001)^(1/2)) - (2*x(6) + 2.0)/(4*((x(6) + 1)^2 + 0.0000001)^(1/2)));
	dx(40) = 0;
	dx(41) = -x(40);
	dx(42) = -x(41);
end