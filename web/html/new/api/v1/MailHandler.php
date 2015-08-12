<?php

/**
 * Class to handle all db operations
 * This class will have CRUD methods for database tables
 *
 * @author Ravi Tamada
 * @link URL Tutorial link
 */
class MailHandler {
    private $mail;
    
    function __construct() {
        require_once dirname(__FILE__) . '/EmailTemplates.php';
        require_once dirname(__FILE__) . '/Config.php';
        require_once '../phpmailer/PHPMailerAutoload.php';
        $this->mail = new PHPMailer;
        $this->mail = new PHPMailer;
        $this->mail->isSMTP();                                      // Set mailer to use SMTP
        $this->mail->Host = MAIL_SERVER;                       // Specify main and backup SMTP servers
        $this->mail->SMTPAuth = true;                               // Enable SMTP authentication
        $this->mail->Username = MAIL_USER;         // SMTP username
        $this->mail->Password = MAIL_PASSWORD;                         // SMTP password
        $this->mail->SMTPSecure = MAIL_SECURITY;                            // Enable TLS encryption, `ssl` also accepted
        $this->mail->Port = MAIL_PORT;  
        $this->mail->From = MAIL_FROM;
        $this->mail->FromName = MAIL_FROM_NAME;
        $this->mail->addReplyTo(MAIL_FROM, MAIL_FROM_NAME);
        //$mail->addCC('cc@example.com');
        //$mail->addBCC('bcc@example.com');
        $this->mail->WordWrap = 50;                                 // Set word wrap to 50 characters
        //$mail->addAttachment('/var/tmp/file.tar.gz');         // Add attachments
        //$mail->addAttachment('/tmp/image.jpg', 'new.jpg');    // Optional name
        $this->mail->isHTML(true);                                  // Set email format to HTML
    }

    /* ------------- `users` table method ------------------ */

    /**
     * Send an Email with Template
     * @param String $to Email to send message
     * @param String $email User login email id
     * @param String $password User login password
     */
    public function send_pw_reset_email($to,$id) {
               
        $full_url= BASE_URL . "/#/reset_pw/" . $id;
        $this->mail->addAddress($to); // Add a recipient
        $this->mail->Subject = PW_RESET_SUBJECT;
        $this->mail->Body    = strtr (PW_RESET_BODY, array ('{{res_link}}' => $full_url));;
        //$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
        $resp = $this->mail->send();
        return $resp;
    }
    
     /**
     * Send an Email with Template
     * @param String $to Email to send message
     * @param String $email User login email id
     * @param String $password User login password
     */
    public function send_account_act_email($to,$id) {
        $full_url= BASE_URL . "/#/activate_account/" . $id;
        $this->mail->addAddress($to); // Add a recipient
        $this->mail->Subject = ACTIVATE_ACC_SUBJECT;
        $this->mail->Body    = strtr (ACTIVATE_ACC_BODY, array ('{{res_link}}' => $full_url));;
        //$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';
        $resp = $this->mail->send();
        return $resp;
    }

    
}

?>

