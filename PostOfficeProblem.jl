# POST_OFFICE_PROBLEM
Required = [17, 13, 15, 19, 14, 16, 11]
l=length(Required)

using JuMP, Clp

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[0:l] <=45)		#x[1]= not work in these day 1,2 etc. Full Time
@variable(m, 0 <= k[0:l] <=45)		#k[1]= not work in these day 1,2 etc. Over Time
@expression(m, fte,sum(x))
@expression(m, ote,sum(k))

for i in 1:l
	if i==1
		@constraint(m, fte+ote - (x[end] + x[i] + k[i]) == Required[i] )
	end
	@constraint(m, fte+ote - (x[i-1] + x[i] + k[i]) == Required[i] )
end

@objective(m,Min,fte*100+ote*180)


status = optimize!(m)

println("Minimum labour cost is ",objective_value(m))
println("Minimum fte and ote is ",value(fte),value(ote))
for i in 1:l
	println(value(x[i])," ",value(k[i]))
end