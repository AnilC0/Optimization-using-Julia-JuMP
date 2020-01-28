using JuMP, Cbc

lim = [7 7 7 7 7 7 9 9 9 9 9 5 5 5 5 5 5 5] # speed limit vector
t = 18

m = Model(with_optimizer(Cbc.Optimizer))

#Variables  (Part 1)
@variable(m, gas[1:t],Bin)
@variable(m, brake[1:t],Bin)
@variable(m, 0<= speed[1:t] <= 16,Int)

#Constraints (Part 2)
# C0. initial speed must be 0
@constraint(m, speed[1]==0) 

# C1. Accelaration/deceleration formula
@constraint(m, C1[i in 2:t], speed[i] == speed[i-1] + 2gas[i] - brake[i] - 1)	

# C2 & 3. obeying speed limits and cannot stop
@constraint(m, C2[i in 2:t], 1 <= speed[i] <= lim[i]) 	

#both gas and brake shouldn't be possible
@constraint(m, C0[i in 1:t], gas[i]+brake[i]<=1)



#@objective(m, Min, sum(gas))          		# minimize gas  (Part 3)
@objective(m, Max, sum(speed))        		# maximize sumsspeed  (Part 4)
#@objective(m, Max, 3sum(speed)-sum(gas))   # multiobjective (Part 5)
#@objective(m, Max, sum(speed)/30*18)		# maximize average speed & keep linear (Part 7)

optimize!(m)

############################################
################ PRINT PART ################

print("lim :\t")
for i in 1:18
    print(" ", floor(Int, lim[i]))
end
print("\n")

print("Gas :\t")
for i in 1:18
    print(" ", floor(Int, value(gas[i])))
end
print("\n")

print("brake :\t")
for i in 1:18
    print(" ", floor(Int, value(brake[i])))
end
print("\n")

print("Speed :\t")
for i in 1:18
    print(" ", floor(Int, value(speed[i])))
end
print("\n")
print("Objective cost: \n", objective_value(m))
