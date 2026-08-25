class MlModel < ApplicationRecord

  enum :status,
       {
         development: "development",
         challenger: "challenger",
         champion: "champion",
         retired: "retired"
       }


  validates :name,
            presence: true


  validates :version,
            presence: true


end