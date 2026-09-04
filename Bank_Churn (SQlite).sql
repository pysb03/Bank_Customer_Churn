/*                    (Bank Customer Churn)   
            
Souce: https://mavenanalytics.io/data-playground/bank-customer-churn  	*/



------           CLEAN DATA (Balance)            -------

SELECT * FROM Bank_Churn
WHERE Balance = '-';
-- Check ว่า Balance มี ค่า '-' จริงไหม

UPDATE Bank_Churn
SET Balance = 0 
WHERE Balance = '-';
-- Update เปลี่ยนค่าทั้งหมดที่เป็น '-' --> 0

UPDATE Bank_Churn
SET Balance = Replace(Balance, ',' , '');
-- SQLite มองว่า XXX,XXX.00 มันมอง , เป็น Text ทำให้ มองแค่ XXX 3 ตัวหน้าแทน ทำให้คำนวณผิดพลาดตามมา จึงต้องลบออก

UPDATE Bank_Churn
SET EstimatedSalary = Replace(EstimatedSalary, ',' , '');
-- SQLite มองว่า XXX,XXX.00 มันมอง , เป็น Text ทำให้ มองแค่ XXX 3 ตัวหน้าแทน ทำให้คำนวณผิดพลาดตามมา จึงต้องลบออก


------------------------------------------------------------------------
------------------------/ ข้อมูลทั่วไปของ Data /----------------------------
------------------------------------------------------------------------


---- หา Total Customer ----
SELECT count(*) AS 'Total Customer' FROM Bank_Churn
-- Ans: Total Customer: 10000 ID

---- หา AVG Balance + AVG EstimatedSalary ----
SELECT avg(Balance), avg(EstimatedSalary) 
FROM Bank_Churn
/* Ans:	avg(Balance)	avg(EstimatedSalary)
		76485.889288	100090.239881						*/

---- หา Total Customer ที่ Churn & Non-Churn ----
SELECT ChurnStatus, count(*) AS 'Total Customer' 
FROM Bank_Churn
Group BY ChurnStatus;
/* 	ChurnStatus		Total Customer
	Churner			2037
	Non-Churner		7963				*/

---- หา Avg Age, Avg Tenure ----
SELECT avg(Age), AVG(Tenure) 
FROM Bank_Churn;
/*Ans: 	avg(Age)		AVG(Tenure)
		38.9218			5.0128			*/
		
----- หา Total Sum of Customer by MemberStatus and CrCardStatus -----

SELECT 	MemberStatus, count(CustomerId) AS "Customer_Count"
FROM Bank_Churn 
GROUP BY MemberStatus; 

/* Ans: MemberStatus	Customer_Count
		Active				5151
		Inactive			4849	
*/		
		
SELECT 	CrCardStatus, count(CustomerId) AS "Customer_Count"
FROM Bank_Churn
GROUP BY CrCardStatus; 

/*-- Ans: CrCardStatus	Customer_Count
		Has Card			7055
		No Card				2945 	

-----------------------------------------------------------------
-------------/ หาลักษณะและข้อมูลต่าง ๆ ลูกค้าแต่ละประเทศ /---------------
-----------------------------------------------------------------

SELECT count(CustomerId) AS "Total Customer"
FROM Bank_Churn;

/* Ans: Total Customer Count = 10000 ID */


SELECT 	Geography, 
		COUNT(CustomerId) AS "Customer Count", 
		COUNT(CustomerId) * 100.0 / (SELECT COUNT(CustomerId) FROM Bank_Churn) AS Percentage
FROM Bank_Churn
GROUP BY Geography;

/* Ans: Geography	Customer 	Percentage
		France		5014		50.14% 
		Germany		2509		25.09% 
		Spain		2477		24.77%
*/


SELECT 	Geography, Gender, 
		count(CustomerId) AS "Customer_Count",
		(count(CustomerId) * 100.0 / (SELECT count(CustomerId) FROM Bank_Churn)) AS "Percentage"
FROM Bank_Churn
GROUP BY Geography, Gender;

/* Ans:	Geography	Gender	Customer_Count	Percentage
	1	France		Female		2261		22.61
		France		Male		2753		27.53   
	2	Germany		Female		1193		11.93
		Germany		Male		1316		13.16
	3	Spain		Female		1089		10.89
		Spain		Male		1388		13.88
*/


SELECT Geography, round(avg(Tenure),2) AS 'Avg Tenure'
FROM Bank_Churn
GROUP BY Geography;

/* Ans: Geography	Avg Tenure
		France			5.00
		Germany			5.01
		Spain			5.03
*/


SELECT 	Geography, 
		round(avg(Balance),2) AS 'Avg Balance', 
		round(avg(CreditScore),2) AS 'Avg CreditScore',
		round(avg(EstimatedSalary),2) AS 'Avg Salary'
FROM Bank_Churn
GROUP BY Geography;

/* Ans: Geography	Avg Balance		Avg CreditScore		Avg Salary
		France		62092.64		649.67				99899.18
		Germany		119730.12		651.45				101113.44
		Spain		61818.15		651.33				99440.57
*/ 


/*///// หา Geography + MemberStatus + CrCardStatus /////*/

----- 1. Geography + MemberStatus -----

SELECT 	Geography, MemberStatus, count(CustomerId) AS "Customer_Count",
		round(count(CustomerId) * 100.0 /
				(SELECT count(*) FROM Bank_Churn A WHERE A.Geography = B.Geography),2) AS 'Percentage'
FROM Bank_Churn B
GROUP BY Geography, MemberStatus
Order BY MemberStatus ASC; 

/* Ans: Geography	MemberStatus		Customer_Count	Percentage
		France		Active				2591			51.68
		Germany		Active				1248			49.74
		Spain		Active				1312			52.97 ***
		France		Inactive			2423			48.32
		Germany		Inactive			1261			50.26 ***
		Spain		Inactive			1165			47.03
(พบว่าลูกค้าประเทศ Germany ลูกค้าที่ Inactive มีมากถสุดึง 50.26% 
ส่วนลูกค้าที่มีสถานะ Active อยู่ ในประเทศ Spain มีมากสุดถึง 52.97% เช่นเดียวกัน)
*/		


----- 2. Geography + CrCardStatus -----
		
SELECT 	Geography, CrCardStatus, count(CustomerId) AS "Customer_Count",
		round(count(CustomerId) * 100.0 /
				(SELECT count(*) From Bank_Churn A WHERE A.Geography = B.Geography),2) AS 'Percentage'
FROM Bank_Churn B
GROUP BY Geography, CrCardStatus
ORDER BY CrCardStatus; 

/*-- Ans: 	Geography	CrCardStatus 	Customer_Count		Percentage
			France		Has Card		3543				70.66
			Germany		Has Card		1791				71.38
			Spain		Has Card		1721				69.48
			France		No Card			1471				29.34
			Germany		No Card			718					28.62
			Spain		No Card			756					30.52
(อัตราลูกค้าที่ Has Card มากสุดอยู่ใน Germany ส่วน อัตราที่ลูกค้า No Card มาสุดอยู่ที่ France)		
*/


-------- 3. Geography + MemberStatus + CrCardStatus ---------

SELECT 	Geography, MemberStatus, CrCardStatus,
		count(CustomerId) AS "Customer_Count"
FROM Bank_Churn
GROUP BY Geography, MemberStatus, CrCardStatus; 

/* Ans: Geography	MemberStatus	CrCardStatus	Customer_Count
	1	France		Active			Has Card			1826
		France		Active			*No Card			765
		France		Inactive		Has Card			1717
		France		Inactive		*No Card			706
	2	Germany		Active			Has Card			873
		Germany		Active			*No Card			375
		Germany		Inactive		Has Card			918
		Germany		Inactive		*No Card			343
	3	Spain		Active			Has Card			908
		Spain		Active			*No Card			404
		Spain		Inactive		Has Card			813
		Spain		Inactive		*No Card			352
		
(ถ้าอยากกรอง ใช้ WHERE ก่อน GROUP BY ได้เลย เช่น WHERE MemberStatus = 'Active' เป็นต้น)
*/

-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
------------------/ หาลูกค้าแต่ละ Age Group & Tenure Group /-----------------------
-------------------------------------------------------------------------------

SELECT 	Age_Group, count(CustomerId) AS "Customer Count",
		(count(CustomerId) * 100.0 / (SELECT count(CustomerId) FROM Bank_Churn)) AS Percentage
FROM Bank_Churn
GROUP BY Age_Group
ORDER BY Age_Group ASC;

/* Ans:	Age_Group	Customer Count	Percentage
		18-24		457				4.57
		25-34		3222			32.22
		35-44		3981			39.81
		45-54		1458			14.58
		55-64		600				6.0
		65+			282				2.82
*/

SELECT 	TenureGroup, count(CustomerId) AS 'Customer_Count',
		(count(CustomerId) * 100.0 / 
				(SELECT count(CustomerId) 
						FROM Bank_Churn)) AS ' Percentage'
FROM Bank_Churn
GROUP BY TenureGroup
Order BY TenureGroup ASC;

/* Ans: TenureGroup		Customer_Count		Percentage
		0-2 years		2496				24.96
		3-5 years		3010				30.1
		6-8 years		3020				30.2
		9-10 years		1474				14.74
		(พบว่าระยะเวลาที่ลูกค้ามีส่วนร่วมกับธนาคารนั้น ส่วนใหญ่อยู่ในช่วง 6-8 years, 3-5 years ตามลำดับ)
*/


-------------------------------------------------------------------------------



-------------------------------------------------------------------------------
----------------------/ หา Churner & Non-Churner /-----------------------------
-------------------------------------------------------------------------------


/*/// 1. ChurnStatus ///*/

SELECT 	ChurnStatus, count(CustomerId) AS "Customer_Count",
		(count(CustomerId) * 100.0 / (SELECT count(CustomerId) FROM Bank_Churn)) AS "Percentage"
FROM Bank_Churn
GROUP BY ChurnStatus;

/* Ans: ChurnStatus		Customer_Count	Percentage
		Churner			2037			20.37
		Non-Churner		7963			79.63
*/


/*/// 2. Geography + ChurnStatus ///*/

SELECT 	Geography, ChurnStatus, count(CustomerId) AS "Customer_Count",
		round((count(CustomerId) * 100.0 / 
				(SELECT count(CustomerId) From Bank_Churn A 
						WHERE A.Geography = Bank_Churn.Geography)),2) AS "Percentage"
FROM Bank_Churn
GROUP BY Geography, ChurnStatus;

/* Ans: Geography	ChurnStatus		Customer_Count	Percentage
		France		Churner			810				16.15
					Non-Churner		4204			83.85
		Germany		Churner			814	*			32.44 *
					Non-Churner		1695			67.66
		Spain		Churner			413				16.67
					Non-Churner		2064			83.33

(พบว่า ประเทศที่ Churn Count มากสุดคือ Germany (814) ซึ่งมากถึง 32.44% ของกลุ่มลูกค้าในประเทศ) 			*/


/*/// 3. Geography + Gender + ChurnStatus ///*/

SELECT 	Geography, Gender, ChurnStatus, count(CustomerId) AS "Customer_Count",
		round((count(CustomerId) * 100.0 / 
				(SELECT count(CustomerId) From Bank_Churn A 
						WHERE A.Geography = Bank_Churn.Geography)),2) AS "Percentage"
FROM Bank_Churn
GROUP BY Geography, Gender, ChurnStatus
ORDER BY ChurnStatus;

/* Ans:	Geography	Gender	ChurnStatus	Customer_Count	Percentage
1		France		Female	Churner			460				9.17
		France		Male	Churner			350				6.98
		Germany		Female	Churner			448				17.86 ***
		Germany		Male	Churner			366				14.59
		Spain		Female	Churner			231				9.33
		Spain		Male	Churner			182				7.35
2		France		Female	Non-Churner		1801			35.92
		France		Male	Non-Churner		2403			47.93
		Germany		Female	Non-Churner		745				29.69
		Germany		Male	Non-Churner		950				37.86
		Spain		Female	Non-Churner		858				34.64
		Spain		Male	Non-Churner		1206			48.69
(พบว่า ประเทศ Germany ลูกค้าที่เป็นเพศหญิง มีอัตราการ Churn มากสุด)							*/


/*/// 4. Geography + ActiveStatus + ChurnStatus ///*/

SELECT 	MemberStatus, ChurnStatus, count(CustomerId) AS 'Customer_Count', 
		round(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A WHERE A.MemberStatus = Bank_Churn.MemberStatus),2) AS 'Churn_Rate'
FROM Bank_Churn
WHERE ChurnStatus = 'Churner'
GROUP BY MemberStatus, ChurnStatus;

/*Ans:	MemberStatus	ChurnStatus		Customer_Count	Churn_Rate
		Active			Churner			735				14.27
		Inactive		Churner			1302			26.85
(พบว่า Inactive จะมีอัตราการ Churn มากกว่า)
*/


SELECT 	Geography, MemberStatus, ChurnStatus, count(CustomerId) AS 'Customer_Count', 
		round(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A WHERE A.Geography = Bank_Churn.Geography),2) AS 'Percentage'
FROM Bank_Churn
GROUP BY Geography, ChurnStatus, MemberStatus
Order BY ChurnStatus

/* Ans: Geography	MemberStatus	ChurnStatus	Customer_Count	Percentage
	1	France		Active			Churner			298			5.94
		France		Inactive		Churner			512			10.21
		Germany		Active			Churner			296			11.8
		Germany		Inactive		Churner			518			20.65 ***
		Spain		Active			Churner			141			5.69
		Spain		Inactive		Churner			272			10.98
	2	France		Active			Non-Churner		2293		45.73
		France		Inactive		Non-Churner		1911		38.11
		Germany		Active			Non-Churner		952			37.94
		Germany		Inactive		Non-Churner		743			29.61
		Spain		Active			Non-Churner		1171		47.27
		Spain		Inactive		Non-Churner		893			36.05
(พบว่า Germany ผู้ที่ Inactive มีอัตราการ Churn มากสุด ที่ 20.65% ของลูกค้าทั้งหมดในประเทศ)			*/


SELECT 	TenureGroup, ChurnStatus, count(CustomerId) AS 'Customer_Count', 
		ROUND(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A 
				WHERE A.TenureGroup = Bank_Churn.TenureGroup),2) 
		AS 'Percentage'
FROM Bank_Churn
GROUP BY TenureGroup, ChurnStatus
Order by TenureGroup ASC;

/* Ans: TenureGroup	ChurnStatus	Customer_Count	Percentage
	1	0-2 years	Churner			528				21.15
		0-2 years	Non-Churner		1968			78.85 
	2	3-5 years	Churner			625				20.76
		3-5 years	Non-Churner		2385			79.24
	3	6-8 years	Churner			570				18.87
		6-8 years	Non-Churner		2450			81.13
	4	9-10 years	Churner			314				21.30 ***
		9-10 years	Non-Churner		1160			78.70 		
(กลุ่มลูกค้าที่ Tenure อยู่ในช่วง 9-10 ปี มี อัตราการ Churn มากสุด)						*/		
		
		
SELECT 	CrCardStatus, ChurnStatus, count(CustomerId) AS 'Customer_Count', 
		ROUND(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A 
				WHERE A.CrCardStatus = Bank_Churn.CrCardStatus),2) 
		AS 'Percentage'
FROM Bank_Churn
GROUP BY CrCardStatus, ChurnStatus
Order by CrCardStatus ASC;

/* Ans:	CrCardStatus	ChurnStatus	 	Customer_Count		Percentage
	1	Has Card		Churner			1424				20.18
		Has Card		Non-Churner		5631				79.82
	2	No Card			Churner			613					20.81 ***
		No Card			Non-Churner		2332				79.19				
(ลูกค้าที่ไม่มีบัตรเครดิต (CreditCard) พบว่ามีอัตราการ Churn มากกว่าลูกค้าที่มีบัตริเครดิต) 				
*/


SELECT 	Geography, CrCardStatus, ChurnStatus, count(CustomerId) AS 'Customer_Count', 
		ROUND(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A 
				WHERE A.Geography = Bank_Churn.Geography),2) 
		AS 'Percentage'
FROM Bank_Churn
GROUP BY Geography, CrCardStatus, ChurnStatus
Order by ChurnStatus ASC;
/* Ans: Geography	CrCardStatus	ChurnStatus		Customer_Count		Percentage
		France		Has Card		Churner			569					11.35
		France		No Card			Churner			241					4.81
		Germany		Has Card		Churner			577					23.0
		Germany		No Card			Churner			237					9.45
		Spain		Has Card		Churner			278					11.22
		Spain		No Card			Churner			135					5.45
		France		Has Card		Non-Churner		2974				59.31
		France		No Card			Non-Churner		1230				24.53
		Germany		Has Card		Non-Churner		1214				48.39
		Germany		No Card			Non-Churner		481					19.17
		Spain		Has Card		Non-Churner		1443				58.26
		Spain		No Card			Non-Churner		621					25.07
(พบว่า ลูกค้าในประเทศ Germany ที่่มี Credit Card มีอัตราการการ Churn มากที่สุด ที่ 23.0% และในประเทศนี้้มีอัตราการ Churn ทั้งหมดประมาณ 32.45%)  
(ส่วน France พบว่าลูกค้าที่มี Credit Card มีอัตราการ Non-Churn มากถึง 59.31%)
*/


-----------------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--------------------------/ Segment Analysis /---------------------------------
-------------------------------------------------------------------------------

/* 	จัดกลุ่มแบ่ง Segments สำหรับ Dataset ออกมาในลักษณะที่มี Business Meaning มีดังนี้ 

Segment 1 — High-Value Active 
	ลูกค้าที่: Balance > 127,644 (Percentile 75; High) and IsActiveMember = Active 
	ความหมาย: ลูกค้าที่มีมูลค่าทางการเงินสูงและมี Relationship กับธนาคารค่อนข้างดี 
	
Segment 2 — High-Value Inactive 
	ลูกค้าที่: Balance > 127,644 (Percentile 75; High) and IsActiveMember = Inactive 
	ความหมาย: ลูกค้ามีเงินอยู่กับธนาคารเยอะ แต่ Engagement หรือ Relationship กับธนาคารอยู่ระดับต่ำ
	
Segment 3 — Low-Engagement
	ลูกค้าที่: IsActiveMember = Inactive และ {NumOfProducts = 1 หรือ Balance = 0 (Percentile 25; Low Balance)}
	ความหมาย: ลูกค้าที่มี Relationship กับธนาคารค่อนข้างต่ำ 
	
Segment 4 — Young / Emerging 
	ลูกค้าที่: Age <= 32 (Percentile 25; Younger) and Balance = Low/Medium (Percentile 25/Percentile 50)
	ความหมาย: ลูกค้าที่อายุอยู่ในเกณฑ์อายุน้อย และยังพยว่ามี Relationship กับธนาคารไม่มาก

Segment 5 — Established Customers
	ลูกค้าที่: Age >= 37 (Percentile 50) and Tenure >= 5 (Percentile 50)
	ความหมาย: พฤติกรรมโดยรวม ของลูกค้าที่ไม่เข้าเกณฑ์ต่าง ๆ 
	 
Segment 6 — Other 
	ลูกค้าที่: ลูกค้าทั้งหมดที่ไม่ได้เข้าเกณฑ์ 1–5
	ความหมาย: พฤติกรรมโดยรวม ของลูกค้าที่ไม่เข้าเกณฑ์ต่าง ๆ 

*/


-------- 1. Total Customer by Segment ---------

SELECT Segment, count(CustomerId) AS 'Customer Count'
FROM Bank_Churn
GROUP BY Segment
ORDER BY count(CustomerId) DESC;
/* ANSWER: 	Segment					Customer Count
(Largest)	Low-Engagement			2964
			Other					2379
			Established Customers	1335
			High-Value Active		1253
			High-Value Inactive		1247
(Smallest)	Young / Emerging		822
*/

SELECT Segment, round(count(CustomerId) * 100.0 / (SELECT count(CustomerId) FROM Bank_Churn),2) AS 'Customer Ratio'
FROM Bank_Churn
GROUP BY Segment
ORDER BY count(CustomerId) DESC;
/* ANSWER: 	Segment					Customer Ratio
(Largest)	Low-Engagement			29.64
			Other					23.79
			Established Customers	13.35
			High-Value Active		12.53
			High-Value Inactive		12.47
(Smallest)	Young / Emerging		8.22
*/


--------- 2. Avg Age, Avg Tenure, Avg NumOfProducts ----------	

SELECT 	Segment, 
		round(avg(Age),2) AS 'Average Age',
		round(avg(Tenure),2) AS 'Average Tenure',
		round(avg(NumOfProducts),2) AS 'Average Number of Products'
FROM Bank_Churn
GROUP BY Segment
ORDER BY CASE Segment 
			WHEN 'High-Value Active' THEN 1
			WHEN 'High-Value Inactive' THEN 2
			WHEN 'Low-Engagement' THEN 3
			WHEN 'Young / Emerging' THEN 4
			WHEN 'Established Customers' THEN 5 
			ELSE 6
		END
;
/* ANSWER: 	Segment				Average Age		Average Tenure		Average Number of Products
			High-Value Active		39.77			4.83				1.39
			High-Value Inactive		38.11			5.13				1.38
			Low-Engagement			37.89			5.07				1.45
			Young / Emerging		28.07			5.01				1.73
			Established Customers	47.16			7.27				1.67
			Other					39.31			3.71				1.63
*/
 
--------- 3. Churn Status and Churn Rate by Segment ----------	

SELECT 	Segment, 
		ChurnStatus, 
		count(CustomerId) AS ' Customer Count',
		round(count(CustomerId) * 100.0 / 
				(SELECT count(*) 
					FROM Bank_Churn A 
					WHERE A.Segment=B.Segment),2) AS 'Percentage'
FROM Bank_Churn B
WHERE ChurnStatus = 'Churner'
GROUP by Segment, ChurnStatus
Order by Percentage DESC;
/* ANSWER: 	Segment					ChurnStatus	 	Customer Count		Percentage
			High-Value Inactive		Churner			380					30.47
			Low-Engagement			Churner			744					25.1
			Established Customers	Churner			293					21.95
			High-Value Active		Churner			212					16.92
			Other					Churner			372					15.64
			Young / Emerging		Churner			36					4.38

(Segment: High-Value Inactive พบว่ามีอัตราการ Churn มากสุด)
*/


--------- 4. Avg Balance, Avg Salary, Avg Credit Score ---------

SELECT 	Segment, 
		round(avg(balance),2) AS 'Average Balance',
		round(avg(EstimatedSalary),2) AS 'Average Salary',
		round(avg(CreditScore),2) AS 'Average CreditScore'
FROM Bank_Churn
GROUP BY Segment
ORDER BY CASE Segment 
			WHEN 'High-Value Active' THEN 1
			WHEN 'High-Value Inactive' THEN 2
			WHEN 'Low-Engagement' THEN 3
			WHEN 'Young / Emerging' THEN 4
			WHEN 'Established Customers' THEN 5 
			ELSE 6
		END
;
/* ANSWER: 	Segment					Average Balance		Average Salary		Average CreditScore
			High-Value Active		149243.04 ***		99973.22			654.92
			High-Value Inactive		148857.68			101338.72 ***		644.61
			Low-Engagement			41979.9				100499.67			648.61
			Young / Emerging		26848.35			99891.43			657.73 ***
			Established Customers	59991.65			100193.44			649.03
			Other					69628.09			98998.13			652.06

(พบว่า 	Average Balance: High-Value Active, 
		Average Salary: High-Value Inactive,
		Average CreditScore: Young / Emerging)
*/	


--------- 5. Member Status Ratio  ---------

SELECT 	Segment, 
		MemberStatus,
		round(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A WHERE A.Segment = B.Segment),2) 
				AS 'Percentage'
FROM Bank_Churn B
GROUP by Segment, MemberStatus
ORDER by CASE Segment 
			WHEN 'High-Value Active' THEN 1
			WHEN 'High-Value Inactive' THEN 2
			WHEN 'Low-Engagement' THEN 3
			WHEN 'Young / Emerging' THEN 4
			WHEN 'Established Customers' THEN 5 
			ELSE 6
		END
;
/* ANSWER: 	Segment					MemberStatus			Percentage
	1		High-Value Active		Active					100.0
			High-Value Active		Inactive				0.0
	2		High-Value Inactive		Active					0.0
			High-Value Inactive		Inactive				100.0
	3		Low-Engagement			Active					0.0
			Low-Engagement			Inactive				100.0
	4		Young / Emerging		Active					91.36
			Young / Emerging		Inactive				8.64
	5		Established Customers	Active					85.69
			Established Customers	Inactive				14.31
	6		Other					Active					84.2
			Other					Inactive				15.8
*/


--------- 6. Credit Card Status Ratio ---------	

SELECT 	Segment, 
		CrCardStatus,
		round(count(CustomerId) * 100.0 / 
				(SELECT count(*) FROM Bank_Churn A WHERE A.Segment = B.Segment),2) 
				AS 'Percentage'
FROM Bank_Churn B
GROUP by Segment, CrCardStatus
ORDER by CASE Segment 
			WHEN 'High-Value Active' THEN 1
			WHEN 'High-Value Inactive' THEN 2
			WHEN 'Low-Engagement' THEN 3
			WHEN 'Young / Emerging' THEN 4
			WHEN 'Established Customers' THEN 5 
			ELSE 6
		END
;
/* ANSWER: 	Segment					CrCardStatus		Percentage
	1		High-Value 	Active		Has Card			69.83
			High-Value Active		No Card				30.17
	2		High-Value Inactive		Has Card			72.01
			High-Value Inactive		No Card				27.99
	3		Low-Engagement			Has Card			70.99
			Low-Engagement			No Card				29.01
	4		Young / Emerging		Has Card			69.22
			Young / Emerging		No Card				30.78
	5		Established Customers	Has Card			70.04
			Established Customers	No Card				29.96
	6		Other					Has Card			70.37
			Other					No Card				29.63
*/