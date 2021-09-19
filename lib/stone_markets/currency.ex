defmodule StoneMarkets.Currency do
  use Ecto.Schema

  import Ecto.Changeset

  alias StoneMarkets.Marketplace

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_fields ~w(code decimal_places number)a
  @derive {Jason.Encoder, only: ~w(id name)a ++ @required_fields}
  @available_currency_codes ~w(
    AED
    AFN
    ALL
    AMD
    ANG
    AOA
    ARS
    AUD
    AWG
    AZN
    BAM
    BBD
    BDT
    BGN
    BHD
    BIF
    BMD
    BND
    BOB
    BOV
    BRL
    BSD
    BTN
    BWP
    BYR
    BZD
    CAD
    CDF
    CHE
    CHF
    CHW
    CLF
    CLP
    CNY
    COP
    COU
    CRC
    CUC
    CUP
    CVE
    CZK
    DJF
    DKK
    DOP
    DZD
    ECS
    EGP
    ERN
    ETB
    EUR
    FJD
    FKP
    GBP
    GEL
    GHS
    GIP
    GMD
    GNF
    GTQ
    GYD
    HKD
    HNL
    HRK
    HTG
    HUF
    IDR
    ILS
    IMP
    INR
    IQD
    IRR
    ISK
    JMD
    JOD
    JPY
    KES
    KGS
    KHR
    KMF
    KPW
    KRW
    KWD
    KYD
    KZT
    LAK
    LBP
    LKR
    LRD
    LSL
    LTL
    LVL
    MUR
    NOK
    PYG
    SEK
    THB
    UGX
    WST
    XFU
    ZWL
    LYD
    MVR
    NPR
    QAR
    SGD
    TJS
    USD
    XAF
    XOF
    MAD
    MWK
    NZD
    RON
    SHP
    TMT
    USN
    XAG
    XPD
    MDL
    MXN
    OMR
    RSD
    SLL
    TND
    USS
    XAU
    XPF
    MGA
    MXV
    PAB
    RUB
    SOS
    TOP
    UYI
    XBA
    XPT
    MKD
    MYR
    PEN
    RWF
    SRD
    TRY
    UYU
    XBB
    XTS
    MMK
    MZN
    PGK
    SAR
    STN
    TTD
    UZS
    XBC
    XXX
    MNT
    NAD
    PHP
    SBD
    SVC
    TWD
    VES
    XBD
    YER
    MOP
    NGN
    PKR
    SCR
    SYP
    TZS
    VND
    XCD
    ZAR
    MRO
    NIO
    PLN
    SDG
    SZL
    UAH
    VUV
    XDR
    ZMW
  )

  schema "currencies" do
    field :code, :string
    field :decimal_places, :integer
    field :name, :string
    field :number, :string

    has_many :marketplaces, Marketplace, foreign_key: :default_currency_id

    timestamps()
  end

  def changeset(currency \\ %__MODULE__{}, attrs) do
    currency
    |> cast(attrs, @required_fields ++ [:name])
    |> validate_required(@required_fields)
    |> validate_inclusion(:code, @available_currency_codes)
    |> validate_length(:name, min: 3)
    |> no_assoc_constraint(:marketplaces)
  end
end
