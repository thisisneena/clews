class WaterlowsController < ApplicationController

	def new
		@patient = Patient.find_by_mrn(params[:mrn]) || Patient.find_by_id(params[:patient_id]) || nil
		@waterlow = @patient.try(&:waterlows).try(&:last).try(&:dup) || Waterlow.new(patient: @patient)
	end

	def create
		@waterlow = Waterlow.new(params.require(:waterlow).permit(:patient_id, :height, :weight, :skin_type, :mobility, :continence, :appetite, :special_risks))
		if @waterlow.save
			redirect_to rounds_patients_path
		else
			render :new
		end
	end

	def update

	end

	private
		def observation_params 
			hash = Observation.measurement_types.inject({}) do |data, type|
				data["#{type}_measurement_attributes".to_sym] = [:value]
				data
			end
			params.require(:observation).permit(hash)
		end
end
