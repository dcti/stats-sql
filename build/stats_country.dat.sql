--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;

SET SESSION AUTHORIZATION 'pgsql';

SET search_path = public, pg_catalog;

--
-- Data for TOC entry 2 (OID 117870434)
-- Name: stats_country; Type: TABLE DATA; Schema: public; Owner: pgsql
--

COPY stats_country (code, country) FROM stdin;
af	Afghanistan                                                     
al	Albania                                                         
dz	Algeria                                                         
as	American Samoa                                                  
ad	Andorra                                                         
ao	Angola                                                          
ai	Anguilla                                                        
aq	Antarctica                                                      
ag	Antigua and Barbuda                                             
ar	Argentina                                                       
am	Armenia                                                         
aw	Aruba                                                           
au	Australia                                                       
at	Austria                                                         
az	Azerbaijan                                                      
bs	Bahamas                                                         
bh	Bahrain                                                         
bd	Bangladesh                                                      
bb	Barbados                                                        
by	Belarus                                                         
be	Belgium                                                         
bz	Belize                                                          
bj	Benin                                                           
bm	Bermuda                                                         
bt	Bhutan                                                          
bo	Bolivia                                                         
ba	Bosnia and Herzegowina                                          
bw	Botswana                                                        
bv	Bouvet Island                                                   
br	Brazil                                                          
io	British Indian Ocean Territory                                  
bn	Brunei Darussalam                                               
bg	Bulgaria                                                        
bf	Burkina Faso                                                    
bi	Burundi                                                         
kh	Cambodia                                                        
cm	Cameroon                                                        
ca	Canada                                                          
cv	Cape Verde                                                      
ky	Cayman Islands                                                  
cf	Central African Republic                                        
td	Chad                                                            
cl	Chile                                                           
cn	China                                                           
cx	Christmas Island                                                
cc	Cocos (keeling) Islands                                         
co	Colombia                                                        
km	Comoros                                                         
cg	Congo                                                           
ck	Cook Islands                                                    
cr	Costa Rica                                                      
ci	Cote d'Ivoire                                                   
cu	Cuba                                                            
cy	Cyprus                                                          
cz	Czech Republic                                                  
dk	Denmark                                                         
dj	Djibouti                                                        
dm	Dominica                                                        
do	Dominican Republic                                              
tp	East Timor                                                      
ec	Ecuador                                                         
eg	Egypt                                                           
sv	El Salvador                                                     
gq	Equatorial Guinea                                               
ee	Estonia                                                         
et	Ethiopia                                                        
fo	Faroe Islands                                                   
fj	Fiji                                                            
fi	Finland                                                         
fr	France                                                          
gf	French Guiana                                                   
pf	French Polynesia                                                
tf	French Southern Territories                                     
ga	Gabon                                                           
gm	Gambia                                                          
ge	Georgia                                                         
de	Germany                                                         
gh	Ghana                                                           
gi	Gibraltar                                                       
gr	Greece                                                          
gl	Greenland                                                       
gd	Grenada                                                         
gp	Guadeloupe                                                      
gu	Guam                                                            
gt	Guatemala                                                       
gn	Guinea                                                          
gw	Guinea-Bissau                                                   
gy	Guyana                                                          
ht	Haiti                                                           
hm	Heard and McDonald Islands                                      
hn	Honduras                                                        
hk	Hong Kong                                                       
hu	Hungary                                                         
is	Iceland                                                         
in	India                                                           
id	Indonesia                                                       
iq	Iraq                                                            
ie	Ireland                                                         
il	Israel                                                          
it	Italy                                                           
jm	Jamaica                                                         
jp	Japan                                                           
jo	Jordan                                                          
kz	Kazakhstan                                                      
ke	Kenya                                                           
ki	Kiribati                                                        
kp	Korea, Democratic People's Republic of                          
kr	Korea, Republic of                                              
kw	Kuwait                                                          
kg	Kyrgyzstan                                                      
la	Lao People's Democratic Republic                                
lv	Latvia                                                          
lb	Lebanon                                                         
ls	Lesotho                                                         
lr	Liberia                                                         
ly	Libyan Arab Jamahiriya                                          
li	Liechtenstein                                                   
lt	Lithuania                                                       
lu	Luxembourg                                                      
mo	Macau                                                           
mk	Macedonia, the Former Yugoslav Republic of                      
mg	Madagascar                                                      
mw	Malawi                                                          
my	Malaysia                                                        
mv	Maldives                                                        
ml	Mali                                                            
mt	Malta                                                           
mh	Marshall Islands                                                
mq	Martinique                                                      
mr	Mauritania                                                      
mu	Mauritius                                                       
yt	Mayotte                                                         
mx	Mexico                                                          
fm	Micronesia, Federated States of                                 
md	Moldova, Republic of                                            
mc	Monaco                                                          
mn	Mongolia                                                        
ms	Montserrat                                                      
ma	Morocco                                                         
mz	Mozambique                                                      
mm	Myanmar                                                         
na	Namibia                                                         
nr	Nauru                                                           
np	Nepal                                                           
nl	Netherlands                                                     
an	Netherlands Antilles                                            
nc	New Caledonia                                                   
nz	New Zealand                                                     
ni	Nicaragua                                                       
ne	Niger                                                           
ng	Nigeria                                                         
nu	Niue                                                            
nf	Norfolk Island                                                  
mp	Northern Mariana Islands                                        
no	Norway                                                          
om	Oman                                                            
pk	Pakistan                                                        
pw	Palau                                                           
pa	Panama                                                          
pg	Papua New Guinea                                                
py	Paraguay                                                        
pe	Peru                                                            
ph	Philippines                                                     
pn	Pitcairn                                                        
pl	Poland                                                          
pt	Portugal                                                        
pr	Puerto rico                                                     
qa	Qatar                                                           
re	Reunion                                                         
ro	Romania                                                         
ru	Russian Federation                                              
rw	Rwanda                                                          
kn	Saint Kitts and Nevis                                           
lc	Saint lucia                                                     
vc	Saint Vincent and the Grenadines                                
ws	Samoa                                                           
sm	San Marino                                                      
st	Sao Tome and Principe                                           
sa	Saudi Arabia                                                    
sn	Senegal                                                         
sc	Seychelles                                                      
sl	Sierra Leone                                                    
sg	Singapore                                                       
si	Slovenia                                                        
sb	Solomon Islands                                                 
so	Somalia                                                         
za	South Africa                                                    
gs	South Georgia and the South Sandwich Islands                    
es	Spain                                                           
lk	Sri Lanka                                                       
sh	St. Helena                                                      
pm	St. Pierre and Miquelon                                         
sd	Sudan                                                           
sr	Suriname                                                        
sj	Svalbard and Jan Mayen Islands                                  
sz	Swaziland                                                       
se	Sweden                                                          
ch	Switzerland                                                     
sy	Syrian Arab Republic                                            
tw	Taiwan                                                          
tj	Tajikistan                                                      
tz	Tanzania, United Republic of                                    
th	Thailand                                                        
tg	Togo                                                            
tk	Tokelau                                                         
to	Tonga                                                           
tt	Trinidad and Tobago                                             
tn	Tunisia                                                         
tr	Turkey                                                          
tm	Turkmenistan                                                    
tc	Turks and Caicos Islands                                        
tv	Tuvalu                                                          
ug	Uganda                                                          
ua	Ukraine                                                         
ae	United Arab Emirates                                            
gb	United Kingdom                                                  
us	United States                                                   
um	United States Minor Outlying Islands                            
uy	Uruguay                                                         
uz	Uzbekistan                                                      
vu	Vanuatu                                                         
ve	Venezuela                                                       
vn	Vietnam                                                         
wf	Wallis and Futuna Islands                                       
eh	Western sahara                                                  
ye	Yemen                                                           
yu	Yugoslavia                                                      
zr	Zaire                                                           
zm	Zambia                                                          
zw	Zimbabwe                                                        
hr	Croatia                                                         
sk	Slovakia                                                        
\.


