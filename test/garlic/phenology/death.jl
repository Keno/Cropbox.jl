@system Death(Stage) begin
    dieable => true ~ flag
    dead => begin
        #FIXME implement Count trait equivalent
        #return self.pheno.plant.count.total_dropped_leaves >= self.pheno.leaves_initiated
        false
    end ~ flag
    dying(a=dieable, b=dead) => (a && !b) ~ flag

    # #FIXME postprocess similar to @produce?
    # def finish(self):
    #     #FIXME record event?
    #     GDD_sum = self.pheno.gdd_recorder.rate
    #     T_grow = self.pheno.growing_temperature
    #     print(f"* Death: time = {self.time}, GDDsum = {GDD_sum}, Growing season T = {T_grow}")
end
