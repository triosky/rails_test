# Rails Test Project :)


##Need to create a pluginable module for easy ActiveRecord and Predefine hstore based fields import and export.


* a model will have a field called `properties` (hstore type field)
* a model will associate to a form which defines the data structures of this properties field.
* your work can be a concern which can be easily added to any model.
* your work should implement following 3 methods
   a) import_template  --- which will generate a XLS file for user to do data entry
   b) import(xls_file, form optional) --- which will populate this model's property field. an optional form parameter is here, in case this model doesn't have a static link to a form object.
   c) self.batch_import(xls, form option) ---- which will add multiple records.

##ERD Diagram.

![](https://github.com/triosky/rails_test/blob/master/assets/screen3.png)

##Sample Data and Use case.

![](https://github.com/triosky/rails_test/blob/master/assets/screen1.png)

###form data
```ruby
#<Form:0x007ff74ab7b120> {
              :id => 7,
      :creator_id => nil,
      :company_id => 1,
            :name => "Sign Up Form",
    :introduction => "",
      :created_at => Thu, 21 May 2015 12:39:03 SGT +08:00,
      :updated_at => Thu, 21 May 2015 12:39:03 SGT +08:00,
            :icon => ""
}

[0] #<FormField:0x007ff74a880cb8> {
                :id => 11,
           :form_id => 7,
        :field_type => "single_line",
              :name => "field_1432183083523",
          :required => true,
        :properties => {
                   "hint" => "First, Last",
                  "label" => "Name",
            "placeholder" => "Jon Snow"
        },
          :position => 1,
        :created_at => Thu, 21 May 2015 12:39:03 SGT +08:00,
        :updated_at => Thu, 21 May 2015 12:39:03 SGT +08:00
    },
    [1] #<FormField:0x007ff743521268> {
                :id => 12,
           :form_id => 7,
        :field_type => "email",
              :name => "field_1432183085443",
          :required => false,
        :properties => {
                   "hint" => "",
                  "label" => "Email",
            "placeholder" => "Field placeholder"
        },
          :position => 2,
        :created_at => Thu, 21 May 2015 12:39:03 SGT +08:00,
        :updated_at => Thu, 21 May 2015 12:39:03 SGT +08:00
    },
    [2] #<FormField:0x007ff743520bd8> {
                :id => 13,
           :form_id => 7,
        :field_type => "textarea",
              :name => "field_1432183093239",
          :required => false,
        :properties => {
                   "hint" => "",
                  "label" => "Self Introduction",
            "placeholder" => "Tell us something about yourself."
        },
          :position => 3,
        :created_at => Thu, 21 May 2015 12:39:03 SGT +08:00,
        :updated_at => Thu, 21 May 2015 12:39:03 SGT +08:00
    }
```

###User Data

```ruby
#<FormEntry:0x007ff7426d2040> {
             :id => 1,
        :form_id => 7,
        :user_id => 1,
        :answers => {
        "11" => "Ziwei Zhou",
        "12" => "ziweizhou@test.com",
        "13" => "This is a great day."
    },
     :created_at => Thu, 21 May 2015 12:40:06 SGT +08:00,
     :updated_at => Thu, 21 May 2015 12:40:06 SGT +08:00,
    :approver_id => nil,
         :status => "pending"
}
```



##Advanced Implicit Data and Use case. (Predefined Form)
![](https://github.com/triosky/rails_test/blob/master/assets/screen2.png)

###form data
```ruby
#<Form:0x007ff749645030> {
              :id => 6,
      :creator_id => nil,
      :company_id => 1,
            :name => "Employee Additional Information",
    :introduction => "Extra Information about an employee",
      :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
      :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
            :icon => "fa-group"
}
 => nil
2.1.3 :012 > ap Form.find(6).fields
  Form Load (0.5ms)  SELECT  "forms".* FROM "forms"  WHERE "forms"."id" = $1 LIMIT 1  [["id", 6]]
  FormField Load (0.6ms)  SELECT "form_fields".* FROM "form_fields"  WHERE "form_fields"."form_id" = $1  [["form_id", 6]]
[
    [0] #<FormField:0x007ff7495fc510> {
                :id => 6,
           :form_id => 6,
        :field_type => "personal",
              :name => "field_1432101228591",
          :required => false,
        :properties => {
                                 "hint" => "",
                                "label" => "Personal",
                     "personal_genders" => [
                [0] {
                    "label" => "Male",
                    "value" => "male"
                },
                [1] {
                    "label" => "Female",
                    "value" => "female"
                }
            ],
            "personal_marital_statuses" => [
                [0] {
                    "label" => "Single",
                    "value" => "single"
                },
                [1] {
                    "label" => "Married",
                    "value" => "married"
                },
                [2] {
                    "label" => "Divoced",
                    "value" => "divoced"
                },
                [3] {
                    "label" => "Widowed",
                    "value" => "widowed"
                }
            ]
        },
          :position => 0,
        :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
        :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00
    },
    [1] #<FormField:0x007ff7495f7e20> {
                :id => 7,
           :form_id => 6,
        :field_type => "bank",
              :name => "field_1432101230739",
          :required => false,
        :properties => {
                          "hint" => "",
                         "label" => "Bank",
            "bank_account_types" => [
                [0] {
                    "label" => "Checking",
                    "value" => "checking"
                },
                [1] {
                    "label" => "Saving",
                    "value" => "saving"
                }
            ]
        },
          :position => 1,
        :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
        :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00
    },
    [2] #<FormField:0x007ff7495f7600> {
                :id => 8,
           :form_id => 6,
        :field_type => "compensation",
              :name => "field_1432101233168",
          :required => false,
        :properties => {
                               "hint" => "",
                              "label" => "Compensation",
               "compensation_periods" => [
                [0] {
                    "label" => "Year",
                    "value" => "year"
                },
                [1] {
                    "label" => "Quarter",
                    "value" => "quarter"
                },
                [2] {
                    "label" => "Month",
                    "value" => "Month"
                }
            ],
            "compensation_currencies" => [
                [0] {
                    "label" => "USD",
                    "value" => "usd"
                },
                [1] {
                    "label" => "SGD",
                    "value" => "sgd"
                }
            ]
        },
          :position => 2,
        :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
        :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00
    },
    [3] #<FormField:0x007ff7495f69f8> {
                :id => 9,
           :form_id => 6,
        :field_type => "emergency",
              :name => "field_1432101231904",
          :required => false,
        :properties => {
             "hint" => "",
            "label" => "Emergency"
        },
          :position => 3,
        :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
        :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00
    },
    [4] #<FormField:0x007ff7495f62c8> {
                :id => 10,
           :form_id => 6,
        :field_type => "tax",
              :name => "field_1432101232574",
          :required => false,
        :properties => {
                                  "hint" => "",
                                 "label" => "Tax",
             "tax_decline_with_holdings" => [
                [0] {
                    "label" => "Yes",
                    "value" => "1"
                },
                [1] {
                    "label" => "No",
                    "value" => "0"
                }
            ],
            "tax_filling_status_options" => [
                [0] {
                    "label" => "Joint",
                    "value" => "joint"
                },
                [1] {
                    "label" => "Single",
                    "value" => "single"
                }
            ]
        },
          :position => 4,
        :created_at => Wed, 20 May 2015 13:54:30 SGT +08:00,
        :updated_at => Wed, 20 May 2015 13:54:30 SGT +08:00
    }
]
```

###User Data

```ruby
#<User:0x007ff742539350> {
                        :id => 1,
                     :email => "z@a.com",
                :properties => {
                          "6" => {
                     "address" => "123 Snow Street",
               "date_of_birth" => "1/1/1000",
               "social_tax_id" => "1234567",
            "address_optional" => "",
                      "gender" => "male",
              "marital_status" => "married",
                        "city" => "Singapore",
                       "state" => "",
                         "zip" => "123456",
                     "country" => "Singapore"
        },
                          "7" => [
            [0] {
                     "bank_name" => "CitiBank",
                     "bank_type" => "checking",
                       "routing" => "1",
                "account_number" => "4"
            },
            [1] {
                     "bank_name" => "Chase",
                     "bank_type" => "saving",
                       "routing" => "2",
                "account_number" => "5"
            },
            [2] {
                     "bank_name" => "UOB",
                     "bank_type" => "checking",
                       "routing" => "3",
                "account_number" => "6"
            }
        ],
                          "8" => [
            [0] {
                  "amount" => "10000",
                "currency" => "sgd",
                 "periods" => "year",
                    "date" => "06/01/2015",
                  "reason" => "11111"
            }
        ],
                          "9" => [
            [0] {
                        "name" => "1111",
                "relationship" => "1111",
                "phone_number" => "1111"
            }
        ],
                         "10" => [
            [0] {
                        "filling_status" => "joint",
                  "decline_with_holding" => "1",
                 "withholding_allowance" => "111",
                "additional_withholding" => "1111"
            }
        ],
                  "backup_id" => "",
                  "job_title" => "",
                 "work_email" => "",
            "employment_type" => "",
        "office_phone_number" => ""
    },
                :first_name => "Ziwei",
                 :last_name => "A",
               :manager1_id => nil,
               :manager2_id => nil
}
```
