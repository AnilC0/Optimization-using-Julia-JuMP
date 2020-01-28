using JuMP, Clp, Printf

d = [40 60 70 25]                   # monthly demand for boats

m = Model(with_optimizer(Clp.Optimizer))
	##	Q1 represents by [2]	##
@variable(m, 0 <= x[1:5] <= 40)       # Regular labor		Q1 represents by x[2]
@variable(m, y[1:5] >= 0)             # Overtime labor
@variable(m, h[1:6] >= 0)             # boats held in inventory
@variable(m, hn[1:6] >= 0)			  # boats that unmet demand 
@variable(m, cp[2:5] >= 0)			# positive
@variable(m, cn[2:5] >= 0)			# negative

@constraint(m, flow1[i in 2:5], cp[i]-cn[i] == x[i]+y[i] -(x[i-1]+y[i-1]) )
@constraint(m, flow3[i in 2:5], h[i] - hn[i] == h[i-1]-hn[i-1]+x[i]+y[i]-d[i-1])

@constraint(m, h[2]    == 10)
@constraint(m, hn[end] <= 0)
@constraint(m, h[1]    == 0)
@constraint(m, hn[1]   == 0)	
@constraint(m, x[1]+y[1]==50)
@constraint(m, h[end]>=10)										# 10 boats at hand at the end

@objective(m, Min, 400*sum(x[2:5]) + 450*sum(y[2:5]) + 20*sum(h) + 400*sum(cp) + 500*sum(cn) - 100*sum(hn) )  # minimize costs

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d\n", value(x[2]), value(x[3]), value(x[4]), value(x[5]))
@printf("Boats to build extra labor: %d %d %d %d\n", value(y[2]), value(y[3]), value(y[4]), value(y[5]))
@printf("Inventories: %d %d %d %d %d\n ", value(h[2]), value(h[3]), value(h[4]), value(h[5]), value(h[6]))

@printf("Objective cost: %f\n", objective_value(m))