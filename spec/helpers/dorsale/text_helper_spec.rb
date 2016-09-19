require 'rails_helper'

describe Dorsale::TextHelper, type: :helper do
  it "hours" do
    expect(hours(nil)).to be nil
    expect(hours(1)).to eq "1,00 heure"
    expect(hours(3)).to eq "3,00 heures"
    expect(hours(3.5)).to eq "3,50 heures"
    expect(hours(3.123)).to eq "3,12 heures"
  end

  it "number" do
    expect(number(nil)).to be nil
    expect(number(1)).to eq "1"
    expect(number(1.2)).to eq "1,20"
    expect(number(1.234)).to eq "1,23"
    expect(number(123456.789)).to eq "123 456,79"
  end

  it "percentage" do
    expect(percentage(nil)).to be nil
    expect(percentage(1)).to eq "1\u00A0%"
    expect(percentage(1.123)).to eq "1,12\u00A0%"
  end

  it "euros" do
    expect(euros(nil)).to be nil
    expect(euros(1)).to eq "1\u00A0€"
    expect(euros(1.123)).to eq "1,12\u00A0€"
  end

  it "date" do
    expect(date(nil)).to be nil
    expect(date(Date.parse("2012-12-21"))).to eq "21/12/2012"
  end

  it "text2html" do
    expect(text2html(nil)).to be nil
    expect(text2html(" \n")).to be nil
    expect(text2html("hello\nworld")).to eq "hello<br />world"
    expect(text2html("hello\r\nworld")).to eq "hello<br />world"
    expect(text2html("\n\nhello\nworld\n\n\n")).to eq "hello<br />world"
    expect(text2html("<b>hello</b> world")).to eq "hello world"
  end

  it "should work with module calls" do
    expect(Dorsale::AllHelpers.number(1.2)).to eq "1,20"
  end

  describe "#info" do
    let(:quotation_line) {
      l = create(:billing_machine_quotation_line,
        :unit     => "abc",
        :quantity => 1000.17,
      )

      def l.date; Date.parse("2015-01-25"); end
      def l.time; Time.parse("2015-01-25  17:09:23"); end
      def l.paid?; true end
      l
    }

    it "should work with strings" do
      expect(info quotation_line, :unit).to eq %(<div class="info"><strong class="info-label">Unité</strong><span class="info-separator"> : </span><span class="info-value quotation_line-unit">abc</span></div>)
    end

    it "should accept other tags" do
      expect(info quotation_line, :unit, nil, tag: :p).to eq %(<p class="info"><strong class="info-label">Unité</strong><span class="info-separator"> : </span><span class="info-value quotation_line-unit">abc</span></p>)
    end

    it "should accept custom separator" do
      expect(info quotation_line, :unit, separator: "->").to eq %(<div class="info"><strong class="info-label">Unité</strong><span class="info-separator">-&gt;</span><span class="info-value quotation_line-unit">abc</span></div>)
    end

    it "should accept nested values" do
      expect(info quotation_line.quotation, :state).to eq %(<div class="info"><strong class="info-label">État</strong><span class="info-separator"> : </span><span class="info-value quotation-state">En attente</span></div>)
    end

    it "should override value" do
      expect(info quotation_line, :unit, "zzzzz").to include "zzzzz"
    end

    it "should work with floats" do
      expect(info quotation_line, :quantity).to include "1 000,17"
    end

    it "should work with date" do
      expect(info quotation_line, :date).to include "25/01/2015"
    end

    it "should work with time" do
      expect(info quotation_line, :time).to include "25/01/2015 à 17:09"
    end

    it "should work with booleans" do
      expect(info quotation_line, :paid?).to include "Oui"
    end

    it "should accept helper" do
      expect(info quotation_line, :quantity, helper: :euros).to include "1\u00A0000,17\u00A0€"
    end

    it "should work with class" do
      expect(info Dorsale::CustomerVault::Person, :count, 123).to eq %(<div class="info"><strong class="info-label">Nombre de contacts</strong><span class="info-separator"> : </span><span class="info-value person-count">123</span></div>)
    end
  end

end
