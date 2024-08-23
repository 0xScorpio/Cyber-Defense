Insecure deserialization is when user-controllable data is deserialized by a website. This potentially enables an attacker to manipulate serialized objects in order to pass harmful data into the application code.

It is even possible to replace a serialized object with an object of an entirely different class. Alarmingly, objects of any class that is available to the website will be deserialized and instantiated, regardless of which class was expected. For this reason, insecure deserialization is sometimes known as an "object injection" vulnerability.
An object of an unexpected class might cause an exception. By this time, however, the damage may already be done. Many deserialization-based attacks are completed before deserialization is finished. This means that the deserialization process itself can initiate an attack, even if the website's own functionality does not directly interact with the malicious object. For this reason, websites whose logic is based on strongly typed languages can also be vulnerable to these techniques.

## Impact
The impact of insecure deserialization attacks is in most cases very severe, as it provides an entry point to a vast attack surface.
An attacker might leverage existing application or injected assets and code in malicious ways to perform any of the following attacks:
	• Remote code execution (highly common via insecure deserialization techniques)
	• Privilege escalation
	• Arbitrary file access
	• Denial-of-service attacks
	• Persistent backdoor into the organization's systems
	• Long-term compromise that can go unnoticed for an extended period.
	
## Recommendations
Deserialization of user-controlled objects should be avoided unless absolutely necessary. The high severity of exploits that it potentially enables, and the difficulty in protecting against them, outweigh the benefits in almost any case.
However if deserializing data from untrusted sources is strictly necessary, then the web application should incorporate robust measures to make sure that the data has not been tampered with.
If possible, you should avoid using generic deserialization features altogether. Serialized data from these methods contains all attributes of the original object, including private fields that potentially contain sensitive information. Instead, you could create your own class-specific serialization methods so that you can at least control which fields are exposed.
Finally, remember that the vulnerability is the deserialization of user input, not the presence of gadget chains that subsequently handle the data. Don't rely on trying to eliminate gadget chains that you identify during testing. It is impractical to try and plug them all due to the web of cross-library dependencies that almost certainly exist on your website. At any given time, publicly documented memory corruption exploits are also a factor, meaning that your application may be vulnerable regardless.

## Technical enforcement
If possible, you should avoid using generic deserialization features altogether. If necessary, however, implement a digital signature to check the integrity of the data, bearing in mind that any checks must take place before the deserialization process begins or they will not serve the purpose.
Additionally, create class-specific and highly limited custom deserialization methods by only exposing essential fields.![image](https://github.com/user-attachments/assets/747e8222-40df-47fa-be05-1050c46e5ee7)
