import 'package:flutter/material.dart';
import 'package:roccabox_agent/main.dart';
import 'package:roccabox_agent/util/languagecheck.dart';

class Privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    LanguageChange languageChange = new LanguageChange();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Color(0xff000000),
        ),
        backgroundColor: Color(0xffFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: Text(
          //Privacy and Security
          languageChange.PRIVACY[langCount],
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
                'PRIVACY POLICY',
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
                            'This privacy policy is effective from 1st April 2020. Any future changes to this policy will be clearly displayed here, and you will be deemed to have accepted the terms of the Privacy Policy upon your first use of the website following the changes. We recommend that you check this page frequently to keep up to date with our Privacy Policy.\n\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text:
                                'At Roccabox we know that any personal information you provide us with is private and will only be used as described below. This page describes our privacy policy and how your personal information will be used, how we obtain such information and how we will store your details. By visiting this website, you are accepting and consenting to the practices described in this privacy policy.\n\nIn general, your personal information will be used to improve the features and services we offer, support our own marketing and promotion campaigns, and to keep you informed with information relevant to your property search, purchase or sale.\n\n',
                            // 'This privacy policy is effective from 1st April 2020. Any future changes to this policy will be clearly displayed here, and you will be deemed to have accepted the terms of the Privacy Policy upon your first use of the website following the changes. We recommend that you check this page frequently to keep up to date with our Privacy Policy.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff706C6C),
                              height: 1.5,
                              wordSpacing: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: 'What information do we collect?\n',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text:
                                'If you are searching for a property online, we collect information from you when you register on our website or fill out a form on our website. The information we collect includes your title, name, surname, nationality, email address and, if you choose to provide it, your telephone number. In order for us to evaluate the ways in which the website is being used, certain non-personal information related to your web browsing may also be collected while you are using the website.\n\nIf you buy or sell a property with us, we will add more data to this information (economic and financial, other personal circumstances), which you will be asked for in order to comply with Spanish Laws and Regulations and for us to fully provide the contracted service both legally and professionally.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff706C6C),
                              height: 1.5,
                              wordSpacing: 1.5,
                            ),
                          ),
                          TextSpan(
                            text:
                                '\n\nWho do we disclose this information to?\n',
                            style: TextStyle(
                                fontSize: 20,
                                color: Color(0xff000000),
                                fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text:
                                'In the event of a client purchasing or selling a property via Roccabox, your personal contact information may be disclosed to a currency exchange partner, Lawyer handling your purchase/sale or a rental agency/third party related to the sale (such as a builder, decorator) who will use it to carry out their commercial operations. We will always ask you directly if you are happy to be contacted by any third party related to the sale/purchase of a property prior to passing your details over.',
                            //  'If you are searching for a property online, we collect information from you when you register on our website or fill out a form on our website. The information we collect includes your title, name, surname, nationality, email address and, if you choose to provide it, your telephone number. In order for us to evaluate the ways in which the website is being used, certain non-personal information related to your web browsing may also be collected while you are using the website.\n\nIf you buy or sell a property with us, we will add more data to this information (economic and financial, other personal circumstances), which you will be asked for in order to comply with Spanish Laws and Regulations and for us to fully provide the contracted service both legally and professionally.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff706C6C),
                              height: 1.5,
                              wordSpacing: 1.5,
                            ),
                          ),
                          newMethod('How do we protect your information??'),
                          info(
                              'We know that the ways in which we use and store your information is very important to you, and we appreciate your trust in us to do that responsibly and carefully.\nWe are committed to ensuring that your information is secure, and in order to prevent unauthorised access or disclosure, we have put in place suitable physical, electronic and management structure/procedures to safeguard and protect the information we collect from you, both online and via the telephone.'),
                          newMethod('How can you access your Data?'),
                          info(
                              'You have the legal right to ask for a copy of any of your personal date which is held by us (where such data is held).  Please contact us for more details at info@roccabox.com, or call 0034 951 120 467, or contact us by post at: Roccabox Property Group S.L, Calle Los Jazmines 372, Nueva Andalucia, 29660 Marbella, Malaga, Spain.'),
                          newMethod('Links to other websites'),
                          info(
                              'Our website contains several links to other websites of interest which are related to a property purchase/sale with Roccabox. Once you have used these links to leave our site, you should note that we do not have any control over these websites. We cannot, therefore, be held responsible for the protection and privacy of any information that you may provide whilst visiting such sites, and such sites are not governed by our privacy policy. You should always exercise caution and read the privacy policy applicable to every website you visit before re submitting personal information.'),
                          newMethod('Reviews and comments'),
                          info(
                              'We use various websites in order for our clients to leave impartial reviews about our agency, including www.facebook.com and www.feefo.com. Our clients are all offered the opportunity to leave impartial comments or feedback about their buying or selling experience with Roccabox, but you will not be asked to submit any personal details on these websites (such as your name, where you have purchased/sold etc).'),
                          newMethod('Emails'),
                          info(
                              'All personal data which is contained in emails received via any email address you use to contact us will be used solely to contact you and to send you any information which you have requested or that we think may be of use to you or related to your property search/sale, and to subscribe or unsubscribe you to our newsletters. To unsubscribe please email us at unsubscribe@roccabox.com.'),
                          newMethod('Cookies and tracking'),
                          info(
                              'Like most websites, we use “cookies” to enable us to personalise your visits to this website, simplify the signing-in procedure (if applicable), keep track of your preferences and to track the usage of our website. Cookies are small pieces of information that are stored in the hard drive of your computer by your browser. Your browser will have the option to prevent websites using cookies but please note that this may cause you problems when trying to use ours and other websites.\nLike all websites, our servers automatically record log files containing information about the volume and characteristics of our website traffic, for example an IP address, numbers of pages viewed, length of time spent on site etc. We may use log files to build pictures of how our site is used that help us to monitor and improve the service we offer you, the client. We cannot identify you from your log files.'),
                          newMethod(
                              'Property details displayed on our website'),
                          info(
                              'If you are the owner of a property being displayed for sale or for rent on our website this is because you have signed a vendor/agent agreement form or the agent you have chosen to use for the sale or the letting of your property is a member of the same multi listing service that we are, therefore enabling us to display the details of your property on our website and thereby place the information about your property fully in the public domain. If this is the case we hold no personal information about you or the property you have placed for sale with the other agent and accept no responsibility for any errors shown.'),
                          newMethod(
                              'What will happen if our business changes ownership?'),
                          info(
                              'We may, from time to time, expand or contract our business which may involve the sale and/or the transfer of control of all or part of our business. Data provided by users will, where it is relevant to any part of our business so transferred, be transferred along with that part and the new owner or newly controlling party will, under the terms of this Privacy Policy, be permitted to use the data for the purposes for which it was originally collected by Roccabox. In the event that any of your data is to be transferred in such a manner, you will not be contacted in advance and informed of the changes. When contacted you will not, however, be given the choice to have your data deleted or withheld from the new owner or controller of the business.'),
                          newMethod('User rights\n'),
                          info(
                              'We would like to inform you that you may exercise your right to modify, access, remove and cancel the use of your personal data by email to unsubscribe@roccabox.com. Alternatively you can call us on 0034 951 120 467, or contact us by post at: Roccabox Property Group S.L, Calle Los Jazmines 372, Nueva Andalucia, 29660 Marbella, Malaga, Spain.'),
                          newMethod('Changes to the policy\n'),
                          info(
                              'We may change this policy from time to time as we add new services, features or in response to changes in the law or our commercial arrangements. We will not inform our clients or users of this website of any such changes other than the above wording will be adjusted.')
                        ]),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  TextSpan info(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 14,
        color: Color(0xff706C6C),
        height: 1.5,
        wordSpacing: 1.5,
      ),
    );
  }

  TextSpan newMethod(String text) {
    return TextSpan(
      text: '\n\n$text\n',
      style: TextStyle(
          fontSize: 20, color: Color(0xff000000), fontWeight: FontWeight.w400),
    );
  }
}


