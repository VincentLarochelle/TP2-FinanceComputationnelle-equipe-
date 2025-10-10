using Random, Statistics, Distributions
using Plots

# Problème 5
function simulation_prix_action(μ, σ, Δt, T, S0)
    
    μ_journee = μ / 365
    σ_journee = σ / sqrt(365)
    S = S0
    n_sauts = Int(T / Δt)
    
    for i in 1:n_sauts
        Z = randn()
        ΔW = sqrt(Δt) * Z
        ΔS_S = μ_journee * Δt + σ_journee * ΔW
        S = S * (1 + ΔS_S)
    end
    
    return S
end

function multiples_simulations(μ, σ, Δt, T, S0, n_simulations)

    results = zeros(n_simulations)
    
    for i in 1:n_simulations
        results[i] = simulation_prix_action(μ, σ, Δt, T, S0)
    end
    
    return results
end


μ = 0.1          
σ = 0.3          
Δt = 1           
T = 90           
S0 = 100         
n_simulations = 10000  

println("Début de la simulation avec $n_simulations réalisations...")
prix_finaux = multiples_simulations(μ, σ, Δt, T, S0, n_simulations)

prix_moyen = mean(prix_finaux)
prix_std = std(prix_finaux)
prix_median = median(prix_finaux)
prix_min = minimum(prix_finaux)
prix_max = maximum(prix_finaux)

println("\n=== RÉSULTATS DE LA SIMULATION ===")
println("Prix initial S(0) = $S0")
println("Horizon temporel T = $T jours")
println("Nombre de simulations: $n_simulations")
println("\nStatistiques de S(T):")
println("Moyenne: ", round(prix_moyen, digits=4))
println("Écart-type: ", round(prix_std, digits=4))
println("Médiane: ", round(prix_median, digits=4))
println("Minimum: ", round(prix_min, digits=4))
println("Maximum: ", round(prix_max, digits=4))

p1 = histogram(prix_finaux, bins=50, label="Distribution simulée",
              xlabel="Prix S(T)", ylabel="Fréquence",
              title="Distribution du prix de l'action après $T jours")
vline!([prix_moyen], line=:dash, color=:red, label="Moyenne simulée", linewidth=2)



# Problème 6
function analyser_effets_parametres()
    μ = 0.1; Δt = 1; S0 = 100; n_sim = 10000
    
    volatilites = [0.1, 0.3, 0.5, 0.8]
    T_fixe = 90
    
    p2 = plot(title="Effet de la volatilité σ (T=90 jours)", xlabel="Prix S(T)", ylabel="Densité")
    for σ in volatilites
        prix_finaux = [simulation_prix_action(μ, σ, Δt, T_fixe, S0) for _ in 1:n_sim]
        density!(prix_finaux, label="σ=$σ", linewidth=2)
    end
    
    σ_fixe = 0.3
    temps = [30, 90, 180, 365]
    
    p3 = plot(title="Effet du temps T (σ=0.3)", xlabel="Prix S(T)", ylabel="Densité")
    for T in temps
        prix_finaux = [simulation_prix_action(μ, σ_fixe, Δt, T, S0) for _ in 1:n_sim]
        density!(prix_finaux, label="T=$T jours", linewidth=2)
    end
    
    p_final = plot(p2, p3, layout=(2,1), size=(800, 600))
    return p_final
end

display(p1)  
p6 = analyser_effets_parametres()
display(p6)