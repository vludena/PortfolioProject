/*
Cleaning Data in SQL Queries 
*/

Select *
From PortfolioProject..Nashvillehousing;

--Standadize Date Formt

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..Nashvillehousing


Update Nashvillehousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE Nashvillehousing
Add SaleDateConverted Date;

Update Nashvillehousing 
SET SaleDateConverted = CONVERT(Date, SaleDate)

-------------------------------------------------------------------------------------
---Populate Property Address data

Select *
From PortfolioProject..Nashvillehousing
Where propertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashvillehousing a
JOIN PortfolioProject..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
SET propertyaddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..Nashvillehousing a
JOIN PortfolioProject..Nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

-----Breaking out Address into individual columns (Address, City, State) 

Select PropertyAddress
From PortfolioProject..Nashvillehousing
--Where propertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address 
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address 

From PortfolioProject..Nashvillehousing

ALTER TABLE Nashvillehousing
Add PropertySplitAddres Nvarchar(255);

Update Nashvillehousing 
SET PropertySplitAddres = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE Nashvillehousing
Add PropertySplitCity Nvarchar(255);

Update Nashvillehousing 
SET PropertySplitAddres = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


Select *
From PortfolioProject..Nashvillehousing


Select OwnerAddress
From PortfolioProject..Nashvillehousing

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From PortfolioProject..Nashvillehousing



ALTER TABLE Nashvillehousing
Add OwnerSplitAddress Nvarchar(255);

Update Nashvillehousing 
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE Nashvillehousing
Add OwnerSplitCity  Nvarchar(255);

Update Nashvillehousing 
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE Nashvillehousing
Add OwnerSplitState  Nvarchar(255);

Update Nashvillehousing 
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select *
From PortfolioProject..Nashvillehousing

--Change Y and N to Yes and No in "Sold as Vacant" field 

Select Distinct (soldAsVacant), COUNT(soldAsVacant)
From PortfolioProject..Nashvillehousing
Group by soldAsVacant
Order by 2


Select SoldAsVacant
	,CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END 
From PortfolioProject..Nashvillehousing

Update Nashvillehousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END 
----------------------------------------------------------------------------------------------------

--Remove duplicates

WITH RowNumCTE AS(

Select *,

ROW_NUMBER()OVER(
PARTITION BY ParcelID,
			 PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num
From PortfolioProject..Nashvillehousing
--Order by ParcelID
---WHERE row_num >1
)
SELECT *
From  RowNumCTE
WHERE row_num >1
Order by Propertyaddress

------------------------------------------------------------------------

--Delete Unused Columns

Select * 
From PortfolioProject..Nashvillehousing

ALTER TABLE PortfolioProject..Nashvillehousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject..Nashvillehousing
DROP COLUMN SaleDate




