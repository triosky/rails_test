module Concerns::FormField::FieldTypeCollection
  extend ActiveSupport::Concern

  FieldConfig = {
    percentage:     {type: 'number',    options: ['label', 'hint', 'required', 'range', 'placeholder']},
    boolean:        {type: 'radio',     options: ['label', 'hint', 'required', 'boolean_label']},
    checkbox:       {type: 'checkbox',  options: ['label', 'hint', 'required', 'field_options']},
    date:           {type: 'date',      options: ['label', 'hint', 'required', 'placeholder']},
    datetime:       {type: 'datetime',  options: ['label', 'hint', 'required', 'placeholder']},
    dropdown:       {type: 'select',    options: ['label', 'hint', 'required', 'field_options', 'prompt']},
    email:          {type: 'email',     options: ['label', 'hint', 'required', 'placeholder']},
    file:           {type: 'file',      options: ['label', 'hint', 'required', 'placeholder']},
    mcq:            {type: 'radio',     options: ['label', 'hint', 'required', 'field_options']},
    radio:          {type: 'radio',     options: ['label', 'hint', 'required', 'field_options']},
    number:         {type: 'number',    options: ['label', 'hint', 'required', 'range']},
    textarea:       {type: 'textarea',  options: ['label', 'hint', 'required', 'placeholder', 'rows']},
    price:          {type: 'number',    options: ['label', 'hint', 'required', 'currency']},
    range:          {type: 'number',    options: ['label', 'hint', 'required', 'range']},
    rating:         {type: 'radio',     options: ['label', 'hint', 'required', 'rating']},
    section:        {type: 'section',   options: ['label', 'description']},
    single_line:    {type: 'text',      options: ['label', 'hint', 'required', 'placeholder']},
    time:           {type: 'time',      options: ['label', 'hint', 'required', 'placeholder']},
    website:        {type: 'url',       options: ['label', 'hint', 'required', 'placeholder']},
    question_group: {type: 'text',      options: ['label', 'hint', 'required', 'groups']},
    advance_group:  {type: 'text',      options: ['label', 'hint', 'required', 'advance_groups']},
    expense:        {options: ['label', 'hint', 'required', 'expense']},
    travel:         {options: ['label', 'hint', 'required', 'travel']},
    bank:           {options: ['label', 'hint', 'required', 'bank']},
    personal:       {options: ['label', 'hint', 'required', 'personal']},
    tax:            {options: ['label', 'hint', 'required', 'tax']},
    employment:     {options: ['label', 'hint', 'required', 'employment']},
    compensation:   {options: ['label', 'hint', 'required', 'compensation']},
    emergency:      {options: ['label', 'hint', 'required', 'emergency']}
  }

  included do
    extend Enumerize
    enumerize :field_type, in: Enum::FormField::FIELD_TYPE[:options],
                           default: Enum::FormField::FIELD_TYPE[:default],
                           predicates: { prefix: true }
  end
end
