using Distributions, Statistics

function verifier_probabilite(λ, μ, n_sim=100000)
    compteur = 0
    for _ in 1:n_sim
        T_λ = rand(Exponential(1/λ))
        T_μ = rand(Exponential(1/μ))
        if T_λ < T_μ
            compteur += 1
        end
    end
    prob_empirique = compteur / n_sim
    prob_theorique = λ / (λ + μ)
    return prob_empirique, prob_theorique
end

# Test avec différentes valeurs de λ et μ
println("Validation de P(T_λ < T_μ) = λ/(λ+μ)")
println("="^50)

cas_test = [
    (0.5, 0.5),  
    (1.0, 1.0),   
    (2.0, 1.0),  
    (1.0, 2.0),  
    (0.1, 0.9),  
    (0.9, 0.1),  
]

for (λ, μ) in cas_test
    prob_emp, prob_th = verifier_probabilite(λ, μ)
    erreur = abs(prob_emp - prob_th)
    
    println("λ=$λ, μ=$μ")
    println("  Théorique: $(round(prob_th, digits=4))")
    println("  Empirique: $(round(prob_emp, digits=4))")
    println("  Erreur: $(round(erreur, digits=6))")
    println()
end