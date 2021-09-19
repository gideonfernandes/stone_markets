defmodule Testing.ExchangeCurrency do
  alias Testing.{Arithmetic, BackgroundStorage}
  alias Testing.Errors.InvalidArgs

  @currencies ~w(
    USD
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
    BRL
    BSD
    BTN
    BWP
    BYN
    BZD
    CAD
    CDF
    CHF
    CLP
    CNY
    COP
    CRC
    CUC
    CUP
    CVE
    CZK
    DJF
    DKK
    DOP
    DZD
    EGP
    ERN
    ETB
    EUR
    FJD
    FKP
    FOK
    GBP
    GEL
    GGP
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
    KID
    KMF
    KRW
    KWD
    KYD
    KZT
    LAK
    LBP
    LKR
    LRD
    LSL
    LYD
    MAD
    MDL
    MGA
    MKD
    MMK
    MNT
    MOP
    MRU
    MUR
    MVR
    MWK
    MXN
    MYR
    MZN
    NAD
    NGN
    NIO
    NOK
    NPR
    NZD
    OMR
    PAB
    PEN
    PGK
    PHP
    PKR
    PLN
    PYG
    QAR
    RON
    RSD
    RUB
    RWF
    SAR
    SBD
    SCR
    SDG
    SEK
    SGD
    SHP
    SLL
    SOS
    SRD
    SSP
    STN
    SYP
    SZL
    THB
    TJS
    TMT
    TND
    TOP
    TRY
    TTD
    TVD
    TWD
    TZS
    UAH
    UGX
    UYU
    UZS
    VES
    VND
    VUV
    WST
    XAF
    XCD
    XDR
    XOF
    XPF
    YER
    ZAR
    ZMW
  )

  def call(from_code, to_code, value) when from_code in @currencies and to_code in @currencies do
    from_code
    |> BackgroundStorage.fetch_currency_conversion_rates()
    |> handle_fetch(from_code)
    |> do_exchange(to_code, value)
  end

  def call(_, _, _), do: {:error, InvalidArgs.call()}

  defp client do
    :testing
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:exchangerate_api_adapter)
  end

  defp handle_fetch(nil, from_code), do: client().call(from_code)
  defp handle_fetch({:error, _reason} = error, _from_code), do: error
  defp handle_fetch(result, _from_code), do: {:ok, result}
  defp do_exchange({:error, _reason} = error, _to_code, _value), do: error

  defp do_exchange({:ok, result}, to_code, value) do
    multiply_currency_value = &(&1 * Arithmetic.cast!(&2, :convert).value)

    exchanged =
      result
      |> Map.get(to_code)
      |> multiply_currency_value.(value)
      |> Arithmetic.cast!(:deconvert)

    {:ok, exchanged.value}
  end
end
