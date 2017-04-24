## refactor this
module PaiementCic::FormHelper
  def paiement_cic_hidden_fields(order, price, order_transaction, options = {})
    oa = PaiementCic.config(price, order_transaction.reference)

    oMac = PaiementCic.new
    sDate = Time.now.strftime("%d/%m/%Y:%H:%M:%S")
    chaine = [oMac.tpe, sDate, oa["montant"], oa["reference"].to_s, oa["texte-libre"], oMac.version, oa["lgue"], oMac.societe, "", "", "", "", "", "", "", "", "", "", ""].join("*")
    chaineMAC = oMac.computeHMACSHA1(chaine)
    
    url_retour      = options[:url_retour] || bank_callback_order_transactions_url
    url_retour_ok   = options[:url_retour_ok] || bank_callback_order_transactions_url(order)
    url_retour_err  = options[:url_retour_err] || bank_err_order_transaction_url(order)
    
    html = '
        <input type="hidden" name="version"           id="version"        value="' + oa["version"] + '" />
        <input type="hidden" name="TPE"               id="TPE"            value="' + oa["TPE"] + '" />
        <input type="hidden" name="date"              id="date"           value="' + oa["date"] + '" />
        <input type="hidden" name="montant"           id="montant"        value="' + oa["montant"] + '" />
        <input type="hidden" name="reference"         id="reference"      value="' + oa["reference"].to_s + '" />
        <input type="hidden" name="MAC"               id="MAC"            value="' + chaineMAC + '" />
        <input type="hidden" name="url_retour"        id="url_retour"     value="' + url_retour + '" />
        <input type="hidden" name="url_retour_ok"     id="url_retour_ok"  value="' + url_retour_ok + '" />
        <input type="hidden" name="url_retour_err"    id="url_retour_err" value="' + url_retour_err + '" />
        <input type="hidden" name="lgue"              id="lgue"           value="' + oa["lgue"] + '" />
        <input type="hidden" name="societe"           id="societe"        value="' + oa["societe"] + '" />
        <input type="hidden" name="texte-libre"       id="texte-libre"    value="' + oa["texte-libre"] + '" />
        <input type="hidden" name="mail"              id="mail"	          value="''" />'

    html.respond_to?(:html_safe) ? html.html_safe : html
  end
end
