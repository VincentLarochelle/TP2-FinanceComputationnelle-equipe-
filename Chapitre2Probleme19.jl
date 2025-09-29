using Distributions, Statistics, Printf

function simuler_colonie(λ=0.05, temps_total=60.0, n_sim=1000)
    temps_doublement = Float64[]
    populations_finales = Int64[]
    
    for _ in 1:n_sim
        population = 1
        temps = 0.0
        premier_doublement = nothing
        
        while temps < temps_total
            # Prochaine division dans la colonie
            temps_suivant = rand(Exponential(1/(λ * population)))
            temps += temps_suivant
            
            if temps > temps_total
                break
            end
            
            population += 1  # Division
            
            # Enregistrer premier doublement
            if population == 2 && premier_doublement === nothing
                premier_doublement = temps
            end
        end
        
        if premier_doublement !== nothing
            push!(temps_doublement, premier_doublement)
        end
        push!(populations_finales, population)
    end
    
    return temps_doublement, populations_finales
end

# Calculs théoriques
λ = 0.05
temps_doublement_theorique = log(2) / λ
population_theorique = exp(λ * 60)

# Simulation
println("=== PROCESSUS DE NAISSANCE PUR ===\n")
td_emp, pop_fin = simuler_colonie()

println("Résultats sur $(length(td_emp)) simulations:")
println("Temps de doublement empirique: $(@sprintf("%.2f", mean(td_emp))) min")
println("Temps de doublement théorique: $(@sprintf("%.2f", temps_doublement_theorique)) min")
println("Population moyenne finale: $(@sprintf("%.2f", mean(pop_fin)))")
println("Population théorique: $(@sprintf("%.2f", population_theorique))")

# Affichage des calculs théoriques
println("\n=== CALCULS THÉORIQUES ===")
println("λ = 0.05 par minute")
println("Doublement colonie: ln(2)/λ = $(@sprintf("%.2f", log(2)/0.05)) min")
println("Doublement bactérie: 1/λ = $(@sprintf("%.2f", 1/0.05)) min")
println("Population à t=60: exp(λ×60) = exp(3) = $(@sprintf("%.2f", exp(3)))")