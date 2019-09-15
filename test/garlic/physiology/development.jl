@system Development(
    Mass,
    Area,
    Count,
    Ratio,
    #Carbon,
    #Nitrogen,
    Water,
    Weight
) begin
    calendar ~ ::Calendar(override)
    weather ~ ::Weather(override)
    sun ~ ::Sun(override)
    soil ~ ::Soil(override)

    phenology(context, calendar, weather, sun, soil): pheno => Phenology(; context=context, calendar=calendar, weather=weather, sun=sun, soil=soil) ~ ::Phenology

    primordia => 5 ~ preserve(parameter)

    bulb => begin end ~ produce

    scape => begin end ~ produce

    root(root, pheno, emerging=pheno.emerging) => begin
        if isempty(root)
            if emerging
                #TODO import_carbohydrate(soil.total_root_weight)
                produce(Root, phenology=pheno)
            end
        end
    end ~ produce

    #TODO pass PRIMORDIA as initial_leaves
    nodal_units(nu, pheno, primordia, germinated=pheno.germinated, dead=pheno.dead, l=pheno.leaves_initiated): nu => begin
        if isempty(nu)
            [produce(NodalUnit, phenology=pheno, rank=i) for i in 1:primordia]
        elseif germinated && !dead
            [produce(NodalUnit, phenology=pheno, rank=i) for i in (length(nu)+1):l]
        end
    end ~ produce

    #TODO find a better place?
    planting_density: PD => 55 ~ preserve(u"m^-2", parameter)
end
