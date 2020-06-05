---
title: Tutorial Email
---

# Configuration for sending email

### **Gmail configuration**

* In a Gmail account, go to Manage your Google Account.
* Click the Security option.
* Find the option → How to sign in to Google, and then → 2-step verification.
* Just follow the steps and soon the 2-step verification will be activated.
* Right after the 2-step verification is Enabled, just click on app passwords.
* The app password will allow you to log in from apps on devices that are not compatible with 2-step verification.
* You need to select the app you want the password and the device type
* So just click on Generate
* Just copy your app password.

### **Configure Project**

* In the project, enter the .env file, in username it is necessary to inform the email that will be used, and then in password put the password of the app that was generated in the Google account.
````
MAIL_DRIVE=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=example@gmail.com
MAIL_PASSWORD=password-app
MAIL_ENCRYPTION=tls
````

### **Configure by Mailtrap**

* Mailtrap is used for email sending tests.
* The first step is to create an account on mailtrap [https://mailtrap.io/](https://mailtrap.io/).
* After creating your account, you will be able to see your username and password.

<img src="/assets/img/email/tutorial-email.png" alt="request">

* In your .env file in your project just configure it, with mailtrap information.
````
MAIL_DRIVE=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=username-mailtrap
MAIL_PASSWORD=password-mailtrap
MAIL_ENCRYPTION=tls
````
* And finally, in the mailtrap just create your inbox to receive emails