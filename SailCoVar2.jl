using JuMP, Cbc, Printf

d = [40 60 70 25]                   # monthly demand for boats noShift

m = Model(with_optimizer(Cbc.Optimizer))
	##	Q1 represents by [2]	##
@variable(m, 0 <= x[1:5] <= 40, Int)       # Regular labor				shift+1
@variable(m, y[1:5] >= 0)             # Overtime labor				shift+1
@variable(m, h[1:6] >= 0)             # boats held in inventory		shift+1
@variable(m, 100 >= cp[2:5] >= 0)			# positive	shift+1
@variable(m, 100 >= cn[2:5] >= 0)			# negative  shift+1

@constraint(m, flow1[i in 2:5], cp[i]-cn[i]==x[i]+y[i]-(x[i-1]+y[i-1]))
@constraint(m, flow2[i in 2:5], h[i-1]+x[i]+y[i] == h[i] +d[i-1])

@constraint(m, h[1] == 10)
@constraint(m, x[1]+y[1]==50)
@constraint(m, h[end]==10)										# 10 boats at hand at the end ROLLING HORISON

@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h) + 400*sum(cp)+500*sum(cn)-400*x[1]-450*y[1]-20*h[1])	# minimize costs (-400.. part is for deleting Q0)

optimize!(m)

@printf("Boats to build regular labor: %d %d %d %d\n", value(x[2]), value(x[3]), value(x[4]), value(x[5]))
@printf("Boats to build extra labor: %d %d %d %d\n", value(y[2]), value(y[3]), value(y[4]), value(y[5]))
@printf("Inventories: %d %d %d %d %d %d\n ", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]), value(h[6]))

@printf("Objective cost: %f\n", objective_value(m))