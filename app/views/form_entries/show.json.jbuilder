json.extract! @entry, :id, :status, :answers, :created_at, :updated_at
json.url company_task_url(@entry, format: :json)
if !@entry.user.nil?
  json.user do
    json.name @entry.user.name
    json.id @entry.user.id
  end
end
json.approver do
  json.name @entry.approver.present? ? @entry.approver.name : ''
  json.id @entry.approver.present? ? @entry.approver.id : ''
end
json.form do
  json.name @entry.form.name
  json.id @entry.form.id
  json.fields(@entry.fields) do |field|
    json.extract! field, :id, :name, :field_type, :required, :properties, :position
    if field.field_options.nil?
      json.options []
    else
      json.options(field.field_options) do |option|
        json.id option.id
        json.name option.name
        json.picture option.picture
      end
    end
  end
end
