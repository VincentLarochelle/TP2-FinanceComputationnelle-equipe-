using Random, Statistics, Distributions, Plots

# Problème 4
function marche_aleatoire(n_pas, σ²)
    
    x, y = 0.0, 0.0
    trajectoire = [(x, y)]
    
    for i in 1:n_pas
        direction = rand() * 2π
        longueur = rand(Normal(0, sqrt(σ²)))
        x += longueur * cos(direction)
        y += longueur * sin(direction)
        push!(trajectoire, (x, y))
    end
    
    return trajectoire
end


function simuler_marches_multiples(n_marcheurs, n_pas, σ²)
    
    positions_finales = []
    
    for i in 1:n_marcheurs
        trajectoire = marche_aleatoire(n_pas, σ²)
        push!(positions_finales, trajectoire[end])
    end
    
    return positions_finales
end


traj_typique = marche_aleatoire(1600, 1)
x_vals = [point[1] for point in traj_typique]
y_vals = [point[2] for point in traj_typique]

p_traj = plot(x_vals, y_vals, linewidth=1, label="Trajectoire",
             title="Marche aléatoire typique (1600 pas, σ²=1)",
             xlabel="Position X", ylabel="Position Y",
             aspect_ratio=:equal)
scatter!([x_vals[1]], [y_vals[1]], color=:green, label="Départ", markersize=5)
scatter!([x_vals[end]], [y_vals[end]], color=:red, label="Arrivée", markersize=5)


n_marcheurs = 1000
variances = [0.5, 1, 2]
liste_n_pas = [20, 400, 1600]

plots_densite = []
for σ² in variances
    positions = simuler_marches_multiples(n_marcheurs, 400, σ²)
    x_fin = [pos[1] for pos in positions]
    y_fin = [pos[2] for pos in positions]
    
    p = scatter(x_fin, y_fin, alpha=0.5, markersize=2, label="",
               title="Positions finales (σ²=$σ², 400 pas)",
               xlabel="Position X", ylabel="Position Y",
               aspect_ratio=:equal)
    push!(plots_densite, p)
end

plots_steps = []
for n_pas in liste_n_pas
    positions = simuler_marches_multiples(n_marcheurs, n_pas, 1)
    x_fin = [pos[1] for pos in positions]
    y_fin = [pos[2] for pos in positions]
    
    p = scatter(x_fin, y_fin, alpha=0.5, markersize=2, label="",
               title="Positions finales ($n_pas pas, σ²=1)",
               xlabel="Position X", ylabel="Position Y",
               aspect_ratio=:equal)
    push!(plots_steps, p)
end

display(p_traj)
display(plot(plots_densite..., layout=(1,3), size=(1200,400)))
display(plot(plots_steps..., layout=(1,3), size=(1200,400)))
