@testset "lotka volterra" begin
    @system LotkaVolterra(Controller) begin
        timestep(t=context.clock.tick): t => 0.01t ~ track(u"hr")
        prey_birth_rate: a => 1.0 ~ track(u"hr^-1")
        prey_death_rate: b => 0.1 ~ track(u"hr^-1")
        predator_death_rate: c => 1.5 ~ track(u"hr^-1")
        predator_reproduction_rate: d => 0.75 ~ track
        prey_initial_population: H0 => 10.0 ~ track
        predator_initial_population: P0 => 5.0 ~ track
        prey_population(a, b, H, P): H => a*H - b*H*P ~ accumulate(init=H0, time=t)
        predator_population(b, c, d, H, P): P => d*b*H*P - c*P ~ accumulate(init=P0, time=t)
    end
    s = instance(LotkaVolterra)
    T = Float64[]
    H = Float64[]
    P = Float64[]
    #TODO: isless() for Var with proper promote_rule
    while Cropbox.value(s.t) <= 20.0u"hr"
        #println("t = $(s.t): H = $(s.H), P = $(s.P)")
        push!(T, Cropbox.value(s.t) |> ustrip)
        push!(H, Cropbox.value(s.H))
        push!(P, Cropbox.value(s.P))
        update!(s)
    end
    @test Cropbox.value(s.t) > 20.0u"hr"
    using Plots
    unicodeplots()
    plot(T, [H P], lab=["Prey" "Predator"], xlab="Time", ylab="Population", xlim=(0, T[end]), ylim=(0, ceil(maximum([H P]))))
end
