﻿using AutoMapper;
using Hmcr.Data.Database.Entities;
using Hmcr.Data.Repositories.Base;
using Hmcr.Model.Dtos;
using Hmcr.Model.Dtos.ActivityCode;
using Hmcr.Model.Utils;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Hmcr.Data.Repositories
{
    public interface IActivityCodeRepository
    {
        Task<IEnumerable<ActivityCodeDto>> GetActiveActivityCodesAsync();
        Task<IEnumerable<ActivityCodeLiteDto>> GetActiveActivityCodesLiteAsync();
        Task<IEnumerable<ActivityCodeDto>> GetActiveActivityCodesByActivityNumbersAsync(List<string> actNumbers);
        Task<PagedDto<ActivityCodeSearchDto>> GetActivityCodesAsync(string[]? maintenanceTypes, decimal[]? locationCodes, bool? isActive, string searchText, int pageSize, int pageNumber, string orderBy, string direction);
        Task<ActivityCodeSearchDto> GetActivityCodeAsync(decimal id);
        Task<HmrActivityCode> CreateActivityCodeAsync(ActivityCodeCreateDto activityCode);
        Task UpdateActivityCodeAsync(ActivityCodeUpdateDto activityCode);
        Task<bool> DoesActivityNumberExistAsync(string activityNumber);
        Task DeleteActivityCodeAsync(decimal id);
        Task<IEnumerable<ActivityCodeSearchExportDto>> GetActivityCodesByFilterAsync(string[]? maintenanceTypes, decimal[]? locationCodes, bool? isActive, string searchText);
    }

    public class ActivityCodeRepository : HmcrRepositoryBase<HmrActivityCode>, IActivityCodeRepository
    {
        private IWorkReportRepository _workReportRepo;
        
        public ActivityCodeRepository(AppDbContext dbContext, IMapper mapper, IWorkReportRepository workReportRepo)
            : base(dbContext, mapper)
        {
            _workReportRepo = workReportRepo;
        }

        public async Task<IEnumerable<ActivityCodeDto>> GetActiveActivityCodesAsync()
        {
            var activities = await DbSet
                .Include(x => x.LocationCode)
                .Include(x => x.HmrServiceAreaActivities)
                .ToListAsync();

            return Mapper.Map<IEnumerable<ActivityCodeDto>>(activities).Where(x => x.IsActive);
        }
        public async Task<IEnumerable<ActivityCodeDto>> GetActiveActivityCodesByActivityNumbersAsync(List<string> actNumbers)
        {
            var activities = await DbSet
                .Include(x => x.LocationCode)
                .Include(x => x.HmrServiceAreaActivities)
                .Where(s => actNumbers.Contains(s.ActivityNumber))
                .ToListAsync();

            var activityCodes = Mapper.Map<IEnumerable<ActivityCodeDto>>(activities).Where(x => x.IsActive);

            foreach (var activityCode in activityCodes)
            {
                HmrActivityCode act =
                    activities
                    .Where(x => x.ActivityCodeId == activityCode.ActivityCodeId).FirstOrDefault();
                activityCode.ServiceAreaNumbers = act.HmrServiceAreaActivities.Select(y=>y.ServiceAreaNumber).ToList();
            }
            return activityCodes;
        }

        public async Task<IEnumerable<ActivityCodeLiteDto>> GetActiveActivityCodesLiteAsync()
        {
            var activities = await DbSet
                .OrderBy(x => x.ActivityNumber)
                .ThenBy(x => x.ActivityName)
                .Select(x => new ActivityCodeLiteDto()
                {
                    Id = x.ActivityCodeId,
                    Name = $"{x.ActivityNumber}-{x.ActivityName}",
                    ActivityNumber = x.ActivityNumber
                })
                .ToListAsync();

            return activities;
        }

        public async Task<HmrActivityCode> CreateActivityCodeAsync(ActivityCodeCreateDto activityCode)
        {
            var activityCodeEntity = new HmrActivityCode();

            Mapper.Map(activityCode, activityCodeEntity);

            //TODO: add in saving of Service Areas
            foreach (var areaNumber in activityCode.ServiceAreaNumbers)
            {
                activityCodeEntity.HmrServiceAreaActivities
                    .Add(new HmrServiceAreaActivity
                    {
                        ServiceAreaNumber = areaNumber
                    });
            }
            await DbSet.AddAsync(activityCodeEntity);
            
            return activityCodeEntity;
        }

        public async Task<ActivityCodeSearchDto> GetActivityCodeAsync(decimal id)
        {
            var activityCodeEntity = await DbSet.AsNoTracking()
                .Include(x => x.HmrServiceAreaActivities)
                .FirstOrDefaultAsync(ac => ac.ActivityCodeId == id);

            if (activityCodeEntity == null)
                return null;

            var activityCode = Mapper.Map<ActivityCodeSearchDto>(activityCodeEntity);

            activityCode.IsReferenced = await _workReportRepo.IsActivityNumberInUseAsync(activityCode.ActivityNumber);

            var serviceAreasNumbers =
                activityCodeEntity
                .HmrServiceAreaActivities //new table
                .Select(s => s.ServiceAreaNumber)
                .ToList();
            activityCode.ServiceAreaNumbers = serviceAreasNumbers;

            return activityCode;
        }

        public async Task<IEnumerable<ActivityCodeSearchExportDto>> GetActivityCodesByFilterAsync(string[]? maintenanceTypes, decimal[]? locationCodes, bool? isActive, string searchText)
        {
            var query = DbSet.AsNoTracking();

            if (maintenanceTypes != null && maintenanceTypes.Length > 0)
            {
                query = query.Where(ac => maintenanceTypes.Contains(ac.MaintenanceType));
            }

            if (locationCodes != null && locationCodes.Length > 0)
            {
                query = query.Where(ac => locationCodes.Contains(ac.LocationCodeId));
            }

            if (isActive != null)
            {
                query = (bool)isActive
                    ? query.Where(ac => ac.EndDate == null || ac.EndDate > DateTime.Today)
                    : query.Where(ac => ac.EndDate != null && ac.EndDate <= DateTime.Today);
            }

            if (searchText.IsNotEmpty())
            {
                query = query
                    .Where(ac => ac.ActivityName.Contains(searchText) || ac.ActivityNumber.Contains(searchText));
            }

            var entityActivities = await query
                .Include(u => u.HmrServiceAreaActivities)
                .Include(u => u.RoadClassRuleNavigation)
                .Include(u => u.RoadLengthRuleNavigation)
                .Include(u => u.SurfaceTypeRuleNavigation)
                .Include(u => u.LocationCode)
                .ToListAsync();

            var activityCodes = Mapper.Map<IEnumerable<ActivityCodeSearchExportDto>>(entityActivities);
            
            var activityServiceArea = entityActivities.SelectMany(u => u.HmrServiceAreaActivities).ToLookup(u => u.ActivityCodeId);
            int totalServiceArea = await DbContext.HmrServiceAreas.AsNoTracking().CountAsync();

            foreach (var activity in activityCodes)
            {
                //build out service area string
                string activityServiceAreas = string.Join(",", activityServiceArea[activity.ActivityCodeId].Select(x => x.ServiceAreaNumber).OrderBy(x => x));
                if (activityServiceAreas.Count(f => f == ',') > 0)
                {
                    activity.ServiceAreas = (activityServiceAreas.Count(f => f == ',') + 1 == totalServiceArea) 
                        ? "ALL"
                        : string.Format("\"{0}\"", activityServiceAreas);
                }
                else
                {
                    activity.ServiceAreas = activityServiceAreas;
                }

                activity.RoadClassRuleName = (activity.RoadClassRuleName == "Default")
                    ? "Not Applicable"
                    : activity.RoadClassRuleName;
                activity.RoadLengthRuleName = (activity.RoadLengthRuleName == "Default")
                    ? "Not Applicable"
                    : activity.RoadLengthRuleName;
                activity.SurfaceTypeRuleName = (activity.SurfaceTypeRuleName == "Default")
                    ? "Not Applicable"
                    : activity.SurfaceTypeRuleName;

                //default is reference to N, following process will check and update if they are in use
                activity.IsReferenced = "N";
            }

            // Find out which activity numbers are being used
            await foreach (var activityNumber in FindActivityNumbersInUseAync(activityCodes.Select(ac => ac.ActivityNumber)))
            {
                activityCodes.FirstOrDefault(ac => ac.ActivityNumber == activityNumber).IsReferenced = "Y";
            }

            return activityCodes;
        }

        public async Task<PagedDto<ActivityCodeSearchDto>> GetActivityCodesAsync(string[]? maintenanceTypes, decimal[]? locationCodes, bool? isActive, string searchText, int pageSize, int pageNumber, string orderBy, string direction)
        {
            var query = DbSet.AsNoTracking();

            if (maintenanceTypes != null && maintenanceTypes.Length > 0)
            {
                query = query.Where(ac => maintenanceTypes.Contains(ac.MaintenanceType));
            }

            if (locationCodes != null && locationCodes.Length > 0)
            {
                query = query.Where(ac => locationCodes.Contains(ac.LocationCodeId));
            }

            if (isActive != null)
            {
                query = (bool)isActive
                    ? query.Where(ac => ac.EndDate == null || ac.EndDate > DateTime.Today)
                    : query.Where(ac => ac.EndDate != null && ac.EndDate <= DateTime.Today);
            }

            if (searchText.IsNotEmpty())
            {
                query = query
                    .Where(ac => ac.ActivityName.Contains(searchText) || ac.ActivityNumber.Contains(searchText));
            }

            var pagedEntity = await Page<HmrActivityCode, HmrActivityCode>(query, pageSize, pageNumber, orderBy, direction);

            var activityCodes = Mapper.Map<IEnumerable<ActivityCodeSearchDto>>(pagedEntity.SourceList);

            // Find out which activity numbers are being used
            await foreach (var activityNumber in FindActivityNumbersInUseAync(activityCodes.Select(ac => ac.ActivityNumber)))
            {
                activityCodes.FirstOrDefault(ac => ac.ActivityNumber == activityNumber).IsReferenced = true;
            }

            var pagedDTO = new PagedDto<ActivityCodeSearchDto>
            {
                PageNumber = pageNumber,
                PageSize = pageSize,
                TotalCount = pagedEntity.TotalCount,
                SourceList = activityCodes,
                OrderBy = orderBy,
                Direction = direction
            };

            return pagedDTO;
        }

        public async Task UpdateActivityCodeAsync(ActivityCodeUpdateDto activityCode)
        {
            var activityCodeEntity = await DbSet
                    .Include(x => x.HmrServiceAreaActivities)
                    .FirstAsync(ac => ac.ActivityCodeId == activityCode.ActivityCodeId);

            activityCode.EndDate = activityCode.EndDate?.Date;

            Mapper.Map(activityCode, activityCodeEntity);

            SyncActivityCodeServiceAreas(activityCode, activityCodeEntity);
        }

        public async Task DeleteActivityCodeAsync(decimal id)
        {
            var activityCodeEntity = await DbSet
                .Include(x => x.HmrServiceAreaActivities)
                .FirstAsync(ac => ac.ActivityCodeId == id);

            foreach( var areaToDelete in activityCodeEntity.HmrServiceAreaActivities)
            {    DbContext.Remove(areaToDelete);
            }

            DbSet.Remove(activityCodeEntity);
        }

        public async Task<bool> DoesActivityNumberExistAsync(string activityNumber)
        {
            return await DbSet.AnyAsync(ac => ac.ActivityNumber == activityNumber);
        }

        private async IAsyncEnumerable<string> FindActivityNumbersInUseAync(IEnumerable<string> activityNumbers)
        {
            foreach (var activityNumber in activityNumbers)
            {
                if (await _workReportRepo.IsActivityNumberInUseAsync(activityNumber))
                    yield return activityNumber;
            }
        }

        private void SyncActivityCodeServiceAreas(ActivityCodeUpdateDto activityCodeUpdateDto, HmrActivityCode activityCodeEntity)
        {
            var areasToDelete =
                activityCodeEntity.HmrServiceAreaActivities.Where(s => !activityCodeUpdateDto.ServiceAreaNumbers.Contains(s.ServiceAreaNumber)).ToList();

            for (var i = areasToDelete.Count() - 1; i >= 0; i--)
            {
                DbContext.Remove(areasToDelete[i]);
            }

            var existingAreaNumbers = activityCodeEntity.HmrServiceAreaActivities.Select(s => s.ServiceAreaNumber);

            var newAreaNumbers = activityCodeUpdateDto.ServiceAreaNumbers.Where(r => !existingAreaNumbers.Contains(r));

            foreach (var areaNumber in newAreaNumbers)
            {
                activityCodeEntity.HmrServiceAreaActivities
                    .Add(new HmrServiceAreaActivity
                    {
                        ServiceAreaNumber = areaNumber,
                        ActivityCodeId = activityCodeEntity.ActivityCodeId
                    });
            }
        }

    }
}
