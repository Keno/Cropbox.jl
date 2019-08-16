mutable struct Timepiece{T<:Number}
    t::T
end

advance!(timer::Timepiece{T}, t=one(T)) where {T<:Number} = (timer.t += t)
reset!(timer::Timepiece) = (timer.t = 0)
update!(timer::Timepiece{T}, t::T) where {T<:Number} = begin
    dt = t - timer.t
    (updated = dt > zero(T)) && advance!(timer, dt)
    #TODO: make sure dt is not negative
    updated
end
update!(timer::Timepiece{T}, t) where {T<:Number} = update!(timer, convert(T, t))

import Base: convert, promote_rule, +
convert(::Type{Timepiece{T}}, timer::Timepiece) where {T<:Number} = timer
convert(::Type{T}, timer::Timepiece) where {T<:Number} = convert(T, timer.t)
# convert(::Type{Timepiece{T}}, t) where T = Timepiece(convert(T, t))
# promote_rule(::Type{Timepiece{T}}, ::Type{U}) where {T,U} = promote_type(T, U)
# +(timer::Timepiece, t) = +(promote(timer, t)...)

struct TimeState{T}
    tick::VarVal{T}
    ticker::Timepiece{T}
    tock::VarVal{Int}
    tocker::Timepiece{Int}
end

TimeState{T}(system, tick, tock="context.clock.tock") where T =
    TimeState(VarVal{T}(system, tick), Timepiece{T}(0), VarVal{Int}(system, tock), Timepiece(0))

check!(s::TimeState) = begin
    if update!(s.ticker, value!(s.tick))
        reset!(s.tocker)
        true
    else
        update!(s.tocker, value!(s.tock))
    end
end
