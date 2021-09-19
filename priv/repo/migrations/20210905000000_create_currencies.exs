defmodule StoneMarkets.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add(:code, :string, null: false)
      add(:decimal_places, :integer, null: false)
      add(:name, :string)
      add(:number, :string, null: false)

      timestamps()
    end
  end
end
