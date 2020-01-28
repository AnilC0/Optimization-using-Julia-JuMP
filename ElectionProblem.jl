#=   ELECTION PROBLEM
Formulate the following problem as a linear program and write the Julia code to find the result.

"250 candidates participated in an election and 5000 voters cast their votes. If the candidates with the same number of votes are grouped in the same group, what is the minimum number of candidates that will be in the largest of these groups?"
=#

using JuMP,Cbc
m = Model(with_optimizer(Cbc.Optimizer))

@variable(m, 0 <= group[0:5000] <= 250,Int)  #each group can have between 0 and 250 candidate 
#for example; the group with 300 votes, 5k votes, 1 votes, 0 votes 

@expression(m, votes[i=0:5000], i*group[i])
#for example; group 5 has x votes

@constraint(m, flow[i in 1:5000], group[i-1] >= group[i])
@constraint(m, sum(group)==250)
@constraint(m, sum(votes)==5000)
@objective(m, Min, group[0])

status = optimize!(m)
for x in 0:99	#first 99 group
	println(value(group[x]))
end