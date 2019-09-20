@system Clock begin
    context ~ ::Nothing
    config ~ ::Config(override)
    init => 0 ~ preserve(u"hr", parameter)
    step => 1 ~ preserve(u"hr", parameter)
    tick => nothing ~ advance(init=init, step=step, unit=u"hr")
end

advance!(c::Clock) = advance!(c.tick)
