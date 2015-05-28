require 'active_support/hash_with_indifferent_access'

PROPS_FOR_FIELD_TYPE = HashWithIndifferentAccess[
  'single_line' => {'label' => 'Name'},
  'email'       => {'label' => 'Email'},
  'textarea'    => {'label' => 'Body'},
  'personal'    => {'label' => 'Personal', 'personal_genders' => [
    {'label' => 'Male', 'value' => 'male'},
    {'label' => 'Female', 'value' => 'female'}
  ]}
]

FactoryGirl.define do
  position = -1

  factory :form do
    # Reset position counter after any new form instance created
    after(:build) do
      position = -1
    end
  end

  factory :form_field do
    form

    sequence(:name) { |n| "field##{n}" }
    sequence(:position) { position += 1 }
    field_type 'single_line'

    after(:build) do |field|
      field.properties = PROPS_FOR_FIELD_TYPE[field.field_type]
    end
  end
end
