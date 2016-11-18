module ApplicationHelper
	def display_date(date)
		date.present? ? date.strftime("%m/%d/%Y") : nil
	end
end
