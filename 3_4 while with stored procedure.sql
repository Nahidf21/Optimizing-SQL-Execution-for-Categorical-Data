
ALTER procedure oes.category_name_proc 
( @category_name varchar(30) ) 

as 
set nocount on;
set xact_abort on;

Begin 
	select 
	pc.category_name ,
	p.product_name,
	count(p.discontinued) as number_of_discount, 
	sum(o.quantity) as total_quantity , 
	round(sum((o.unit_price * o.quantity)),2) as total_sell

from oes.product_categories as pc
left join 
oes.products as p on pc.category_id = p.category_id
left join 
oes.order_items as o on p.product_id = o.product_id
where pc.category_name =  @category_name 
group by pc.category_name, p.product_name
order by pc.category_name, p.product_name

end
GO

DECLARE @CATEGORY_NAMES NVARCHAR(400);
DECLARE @CATEGORY_NAME NVARCHAR(100);
DECLARE @COMMA INT;

-- Define the category names without a trailing comma
SET @CATEGORY_NAMES = 'Cameras and Drones,Computers,Home Security,PC Parts,PC Peripherals,Phones and Accessories,Printing and Office,TV and Audio';

WHILE LEN(@CATEGORY_NAMES) > 0
BEGIN 
    -- Find the position of the first comma
    SET @COMMA = CHARINDEX(',', @CATEGORY_NAMES);

    -- If a comma is found, extract the category name
    IF @COMMA > 0
    BEGIN
        SET @CATEGORY_NAME = LEFT(@CATEGORY_NAMES, @COMMA - 1);
        SET @CATEGORY_NAMES = STUFF(@CATEGORY_NAMES, 1, @COMMA, '');
    END
    ELSE
    BEGIN
        -- If no comma is found, this is the last category
        SET @CATEGORY_NAME = @CATEGORY_NAMES;
        SET @CATEGORY_NAMES = ''; -- Ensure the loop exits
    END
    EXECUTE OES.category_name_proc  @CATEGORY_NAME;
END;
