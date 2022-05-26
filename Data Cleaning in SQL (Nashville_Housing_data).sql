/*
CLEANING DATA
*/

Select *
from PortfolioProject..NashvilleHousingData


--Standardize SaleDate Date Formate 

Select SaleDate
From PortfolioProject..NashvilleHousingData


Alter Table NashvilleHousingData
Add SaleDateConverted Date;


Update NashvilleHousingData
Set SaleDateConverted = CONVERT(Date,SaleDate)


Select SaleDateConverted
From PortfolioProject..NashvilleHousingData


--Populate Property Address data


Select *
From PortfolioProject..NashvilleHousingData
where PropertyAddress is null


Select a.ParcelID,a.PropertyAddress,b.PropertyAddress, Isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousingData a
Join PortfolioProject..NashvilleHousingData b
on 
	a.ParcelID = b.ParcelID
and
	a.[UniqueID ] != b.[UniqueID ]
	
Where a.PropertyAddress is null



Update a
Set PropertyAddress =  Isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousingData a
Join PortfolioProject..NashvilleHousingData b
on 
	a.ParcelID = b.ParcelID
and
	a.[UniqueID ] != b.[UniqueID ]
	
Where a.PropertyAddress is null



--Breaking out the PropertyAddress into Individual columns(Address,city,state)


Select PropertyAddress
From PortfolioProject..NashvilleHousingData


Select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject..NashvilleHousingData


Alter Table NashvilleHousingData
Add PropertySplitAddress nvarchar(255);


Update NashvilleHousingData
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table NashvilleHousingData
Add PropertySplitCity nvarchar(255);


Update NashvilleHousingData
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousingData



--Similarly Breaking out the OwnerAddress into address,city,state


Select OwnerAddress
From PortfolioProject..NashvilleHousingData


Select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From PortfolioProject..NashvilleHousingData


Alter Table NashvilleHousingData
Add OwnerSplitAddress nvarchar(255);


Update NashvilleHousingData
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)


Alter Table NashvilleHousingData
Add OwnerSplitCity nvarchar(255);


Update NashvilleHousingData
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)


Alter Table NashvilleHousingData
Add OwnerSplitState nvarchar(255);


Update NashvilleHousingData
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)



Select *
From PortfolioProject..NashvilleHousingData


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject..NashvilleHousingData
Group by SoldAsVacant
order by 2


--Changing Y and N To YES and NO in SoldAsVacant field 


Select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END
From PortfolioProject..NashvilleHousingData


UPDATE NashvilleHousingData
SET SoldAsVacant = 
	Case When SoldAsVacant = 'Y' Then 'YES'
	 WHEN SoldAsVacant = 'N' THEN 'NO'
	 ELSE SoldAsVacant
	 END


Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject..NashvilleHousingData
Group by SoldAsVacant
order by 2


--Removing Duplicates

With RowNumCTE as
(
Select *,
	ROW_NUMBER() Over(
	Partition By	ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order  by
				UniqueID
				) row_num
From PortfolioProject..NashvilleHousingData
)

Select *
From RowNumCTE
Where row_num >1
order by PropertyAddress


With RowNumCTE as
(
Select *,
	ROW_NUMBER() Over(
	Partition By	ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order  by
				UniqueID
				) row_num
From PortfolioProject..NashvilleHousingData
)

DELETE
From RowNumCTE
Where row_num >1
--order by PropertyAddress


-- Deleting Columns which we don't require 


Select *
From PortfolioProject..NashvilleHousingData

ALTER TABLE  PortfolioProject..NashvilleHousingData
DROP COLUMN OwnerAddress,PropertyAddress,SaleDate,LandUse,
TaxDistrict

