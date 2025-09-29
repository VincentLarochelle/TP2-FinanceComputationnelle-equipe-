using Distributions, Statistics

function simuler_naissance_mort(λ, μ, temps_total=20.0, n_sim=1000)
    populations_finales = Int64[]
    
    for _ in 1:n_sim
        population = 1
        temps = 0.0
        
        while temps < temps_total && population > 0
            # Temps jusqu'au prochain événement
            taux_total = population * (λ + μ)
            Δt = rand(Exponential(1/taux_total))
            
            if temps + Δt > temps_total
                break
            end
            
            temps += Δt
            
            # Décider si naissance ou mort
            if rand() < λ/(λ + μ)
                population += 1  # Naissance
            else
                population -= 1  # Mort
            end
        end
        
        push!(populations_finales, population)
    end
    
    return populations_finales
end

# Simulation pour les trois cas
println("PROCESSUS NAISSANCE-MORT (20 minutes)")
println("="^50)

cas_test = [
    (1.00, 1.0),
    (1.05, 1.0), 
    (1.10, 1.0)
]

for (λ, μ) in cas_test
    println("Simulation pour λ = $λ, μ = $μ...")
    pop_fin = simuler_naissance_mort(λ, μ)
    
    moyenne = mean(pop_fin)
    variance = var(pop_fin)
    prob_extinction = count(iszero, pop_fin) / length(pop_fin)
    
    println("λ = $λ, μ = $μ")
    println("  Population moyenne: $(round(moyenne, digits=4))")
    println("  Variance: $(round(variance, digits=4))")
    println("  Probabilité extinction: $(round(prob_extinction, digits=4))")
    println("  Min-Max: $(minimum(pop_fin)) - $(maximum(pop_fin))")
    println()
end