import 'package:flutter/material.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/util/languagecheck.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

     LanguageChange languagecheck = new LanguageChange();



    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff000000),
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          //Terms & Condition
          languagecheck.TERMS[langCount],
          style: TextStyle(
              fontSize: 16,
              color: Color(0xff000000),
              fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Terms and conditions of use',
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: RichText(
                  text: TextSpan(
                      text:
                          'Please read the following terms and conditions very carefully as they contain important information about your rights and obligations when visiting roccabox.com.\n\n',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff706C6C),
                        height: 1.5,
                        wordSpacing: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Introduction\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              '“We” or “us” or “our” are referring to Roccabox Property Group SL. “You” or “the client” or the “user” is referring to the visitor to roccabox.com. We can be contacted via our contact us page on the website or via email at info@roccabox.com. These terms and conditions are deemed to include our privacy policy and are collectively known as “these Terms”. When you use our website, you agree to be bound by these terms and conditions. If you are not in agreement to be bound by these terms and conditions, you may not use this website.\n\nYou may print and keep a copy of the below terms and conditions. They are a legal agreement between us and can only be modified with our consent. We may change these terms and conditions at our discretion by changing them on the website although you will not be informed of any changes and at this point any older version of these terms and conditions will no longer apply.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nIntellectual property\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'The copyright and all other intellectual property rights in this website (including all database rights, trade marks, service marks, trading names, text, graphics, code, files and links) belong to us. You may not copy, transmit, modify, republish, store, frame, pass-off or link to any material from our website without our prior written consent. We therefore make no warranties or representations as to the accuracy or completeness of any of the information appearing in relation to any linked websites. Links to third parties are for your convenience only. We do not recommend any products or services advertised on those websites even though we may have dealt with any of these third parties in the past. If you decide to visit any third party website linked from our website, you do so at your own risk.\n\nRegarding any property listed on our website, we cannot verify these details and therefore make no warranties or representations as to their accuracy or completeness. If you rely on these details, you are doing so at your own risk.\n\n',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text:
                              '\n\nYour obligations and conduct as a user of our website\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'You accept that you are solely responsible for ensuring that your computer system meets all relevant technical specification necessary to use our website and that your computer system is compatible with our website. You must not misuse our system or this website. In particular, you must not hack into, circumvent security or otherwise disrupt the operation of our system and this website, or attempt to carry out any of the foregoing. You must not use or attempt to use any automated program (including, without limitation, any spider or other web crawler) to access our system or our website, or to search, display or obtain links to any part of our website, other than the home page at roccabox.com, unless the automated program identifies itself uniquely in the User Agent field and is fully compliant with the Robots Exclusion Protocol (a “Permitted Program”). Any such use or attempted use of an automated program (other than a Permitted Program) shall be a misuse of our system and our website. Obtaining access to any part of our system or this Site by means of any such automated programs (other than a Permitted Program) is strictly unauthorised.\n\nYou must not include links to our website in any other website without our prior written consent. In particular (but without limiting the foregoing) you must not include in any other website any “deep link” to any page on our website other than the home page at roccabox.com without our prior written consent.\n\nYou must not upload or use inappropriate or offensive language or content or solicit any commercial services in any communication, form or email you send or submit, from or to the website.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nBanning from the website\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'We reserve the right to bar users from this website and/or restrict or block their access or use of any and all elements of our services, on a permanent or temporary basis at our sole discretion. Any such user shall be notified and must not then attempt to use this website under any other name or through any other user.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nWarranty\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Due to the nature of software and the Internet, we do not warrant that your access to, or the running of this website will be uninterrupted or error/virus free. We shall not be liable if we cannot process your details due to circumstances beyond our reasonable control. The information provided on this website is for general interest only and does not constitute specific advice by anyone at Roccabox Property Group SL. Whilst we endeavour to ensure that the information on the website is accurate, complete and up to date we make no warranties or representations that this is the case. Anything written within the website is purely the views of Roccabox Property Group SL and should not be considered factual in any way, although we aim to be as accurate as we can with any statements made on the website.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nLiability\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Nothing in these terms and conditions will be deemed to exclude our liability to you for death or personal injury arising from our negligence, or for fraudulent misrepresentation. We will not be liable for any failures due to software or Internet errors or unavailability, or any other circumstances beyond our reasonable control. We may put in place such systems as we from time to time see fit to prevent automated programs being used to add details to our contact forms on the website. You are not permitted to use automated programs for such purposes and any such use or attempted use by you of such automated programs is at your own risk. We shall not be liable to you for any consequences arising out of or in connection with any such use or attempted use of automated programs to obtain unauthorised access to our system or this website. We accept no liability for any loss suffered as a result of your use of this website or reliance on any information provided on it and exclude such liability to the fullest extent permitted by law. We shall not be liable to you for any indirect, consequential, special or punitive loss, damage, costs and expenses, loss of profit, loss of business, loss of reputation, depletion of goodwill, loss of, damage to or corruption of data. When you use the “contact forms” on this website to enquire about a particular property or for a call back or for any other reason, all your details will be sent by email directly us. We do not accept any liability for any subsequent communications that you may receive from any third party that may intercept any of this information.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nNotices\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'All notices shall be given to us, by email to info@roccabox.com or to you, by email to the email address that you provide to us at the point of your registration, and may also be amended by you by email to info@roccabox.com. All notices sent by email will be deemed to have been received on receipt.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nCustomer feedback and quality\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'We operate a system to ensure that all customer feedback is dealt with fairly and consistently, and is properly recorded. We welcome any suggestions that you make about how we may improve our service. Please email any suggestions to us at info@roccabox.com. We aim to acknowledge all customer feedback by email.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nPersonal data protection\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'See Privacy Policy\n\n',
                          style: TextStyle(
                              // fontFeatures: ,
                              // fontStyle: FontStyle.,
                              fontSize: 14,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text: 'In general\n\n',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'We may from to time-to-time change the content of this website or suspend or discontinue any aspect of this website, which may include your access to it. Subject to our notifying you to the contrary, any amendments or new content to this website will be subject to these terms and conditions. These terms and conditions are the whole agreement between you (the client or user) and us. You acknowledge that you have not entered into this agreement in reliance on any warranty or representation made by us (unless made fraudulently). If a court decides that any part of these terms and conditions cannot be enforced, that particular part of these terms and conditions will not apply, but the rest of these terms and conditions will. A waiver by a party of a breach of any provision shall not be deemed a continuing waiver or a waiver of any subsequent breach of the same or any other provisions. Failure or delay in exercising any right under these terms and conditions shall not prevent the exercise of that or any other right. You may not assign or transfer any benefit, interest or obligation under these terms and conditions.\n\n',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text:
                              'In visiting this website (roccabox.com) you (the user) agree to all the above terms and conditions.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nRenting Terms and conditions\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Roccabox Property Group SL provides apartments, villas, townhouses or other properties for short and long term rentals on the Costa del Sol. Short-term rentals last for a minimum one-week and long term rentals up to 11 months unless otherwise agreed.\n\nThe following Terms and conditions relate to rentals although the above terms and conditions are also relevant to any rentals entered into with Roccabox Property Group SL.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nReservations & Payments\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Bookings are valid when the booking form has been completed, signed and received by Roccabox Property Group SL. A reservation fee of 20% has been paid within 5 days of receipt of booking documents.\n\nRemaining Payments: 50% of your rental fee is due four weeks before arrival date and the remaining 30% is paid on the arrival day.\n\nIf your occupancy date is within 30 days of the effective date of your reservation you must send 70% of the rental fee to Roccabox Property Group SL and the remaining 30% is paid on the arrival day.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nCancellations\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'All cancellations need to be notified immediately to Roccabox Property Group SL. All payments processed are non refundable.\n\nNon-payments by the due date will be treated as a cancellation.\n\nIt is highly recommended that clients take out a holiday insurance to cover cancellation fees and any potential losses or damages they may suffer.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nSecurity deposit\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'A security deposit will be taken in cash or cheque (or other form of payment previously agreed) on or before arrival date and will be returned within 10 days of the completed tenancy provided that there are no unpaid charges (e.g. Cleaning fees, bills, loss of keys or remote controls etc.) or damage to the apartment. The security deposit will be held by either Roccabox Property Group SL or the owner of the property being rented.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nDuration & Times of Letting\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'The property is available after 4pm on the day of arrival and must be vacated by 10am on the day of departure unless otherwise agreed.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nGeneral conditions\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Roccabox Property Group SL acts as letting agent for the property owner and administers the rental on his or her behalf. The rental contract is between the tenant and the property owner and in accordance with conditions described in the rental contract. Roccabox Property Group SL is empowered to sign on behalf of the owner but is in no way responsible for any problems arising during the letting period.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nTenants Obligations\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'The client agrees to:\n\nPay the full cost of any breakages, losses or damage to the property.\n\nTake good care of the property and leave it in a clean and tidy condition at the end of the holiday or letting period.\n\nReport any damage or loss as it is discovered immediately.\n\nPermit Roccabox Property Group SL access to the property to carry out any maintenance if necessary or to make visits to the property as and when we decide necessary. We will do our best to give the tenant notice when this may be but will not guarantee any particular notice. We carry a spare key to every property and may access the property when the tenant is not present to carry out property inspections.\n\nNot to let or share the property to a third party.\n\nAbide any rules or regulations set by the community.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nInsurance\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'The client is responsible for taking out an adequate insurance policy to cover all risks.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nLiability\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Roccabox Property Group SL and the Owner does not accept any liability for injury, damages or loss caused, or for any such claim by a third party as a consequences of actions by the client(s) and other people occupying the property during the period of the let.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nComplaints\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'All problems should be reported to Roccabox Property Group SL immediately and we will use every effort to ensure quick solutions as well as all reasonable effort to ensure your stay at the property is enjoyable and one that you will want to repeat. We cannot be liable or accept any responsibility for any dissatisfaction that you may have with the property nor do we handle any complaints after departure.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nGoverning Law & Jurisdiction\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'Any legal dispute, which may arise, is mutual between tenant and owner.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '\n\nBreach of Contract\n\n',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                          text:
                              'If there is a breach of any of these conditions by any of the Tenants, the Owner and the Letting Agency reserve the right to re-enter the property and terminate the tenancy without notice nor prejudice to the other rights and remedies of the Owners. Any belongs left at the property will at this point become the property of the owner and/or Roccabox Property Group SL.\n\nIn visiting this website (roccabox.com) you (the user) agree to all the above terms and conditions.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff706C6C),
                            height: 1.5,
                            wordSpacing: 1.5,
                          ),
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
