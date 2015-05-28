require 'spec_helper'

module TsProps
  RSpec.describe "Module" do
    it "version" do
      expect(TsProps::VERSION).to eq "0.1.0"
    end

    it "create form field" do
      field = create(:form_field)
      expect(field.position).to eq 0
      expect(field.name).to match /field/
      expect(field.properties['label']).to eq 'Name'
      expect(field.field_type).to eq 'single_line'
      expect(Form.first.fields.count).to eq 1
    end
  end
end
