MatchConditionCtrl = {}

--概率事件触发
local function ProbabilityHandle(card, data, goalCard)
	-- body
	local anomalyData = {};

	if type(goalCard) ~= "table" or next(goalCard) == nil then
		return;
	end

	--随机概率
	math.randomseed(tostring(os.time()):reverse():sub(1, 6)) 
	local _rand = math.random(1, 100);
	print("MatchConditionCtrl---ProbabilityHandle---_rand=", _rand, data.effmainparam);
	--概率比较
	-- local chance = MatchFunction:getPSFinalChance(data.effmainparam, data.effect, card, goalCard[1]);
	-- if chance < _rand then
	-- 	return;
	-- end
	local immuneType = 0
	if data.effect == E_Effect.EE_TreatmentSeal then
		--治疗封印
		immuneType = E_IMMUNE.EI_TreatmentSealImmune
		anomalyData[1] = E_Anomaly.EA_TreatmentSeal;
		anomalyData[2] = data.effoffparam;
		anomalyData[3] = 0;
	elseif data.effect == E_Effect.EE_ProbabilityPoison then
		--中毒
		immuneType = E_IMMUNE.EI_PoisonImmune
		anomalyData[1] = E_Anomaly.EA_Poisoned;
		anomalyData[2] = 3;
		local dotAdd = card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_DotAdd)
		local splitOfDieYoung = card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_SplitOfDieYoung)
		anomalyData[3] = - MatchFunction:match_round(card:getMatchCardDataAdd():getAttack() * data.effoffparam / 100 * (1 + (dotAdd + splitOfDieYoung) / 100));--之前是扣除固定数值的生命(-data.effoffparam), 现在按 受击方的攻击力乘以被动技能的effoffparam值(百分比) 
	elseif data.effect == E_Effect.EE_ProbabilityFire then
		--灼烧
		immuneType = E_IMMUNE.EI_FireImmune
		anomalyData[1] = E_Anomaly.EA_Fire;
		anomalyData[2] = 3;
		local dotAdd = card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_DotAdd)
		local splitOfDieYoung = card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_SplitOfDieYoung)
		anomalyData[3] = - MatchFunction:match_round(card:getMatchCardDataAdd():getAttack() * data.effoffparam / 100 * (1 + (dotAdd + splitOfDieYoung) / 100));
	elseif data.effect == E_Effect.EE_ProbabilityGiddy then
		--眩晕
		immuneType = E_IMMUNE.EI_GiddyImmune
		anomalyData[1] = E_Anomaly.EA_Giddy;
		anomalyData[2] = data.effoffparam;
		anomalyData[3] = 0;
	elseif data.effect == E_Effect.EE_ProbabilityChaos then
		--混乱
		immuneType = E_IMMUNE.EI_ChaosImmune
		anomalyData[1] = E_Anomaly.EA_Chaos;
		anomalyData[2] = data.effoffparam;
		anomalyData[3] = 0;
	elseif data.effect == E_Effect.EE_ProbabilityStopSkill then
		--封技
		immuneType = E_IMMUNE.EI_StopSkillImmune
		anomalyData[1] = E_Anomaly.EA_StopSkill;
		anomalyData[2] = data.effoffparam;
		anomalyData[3] = 0;
	end

	--遍历作用卡牌
	if goalCard then
		print("MatchConditionCtrl---ProbabilityHandle---遍历作用卡牌, ", #goalCard)
		for k, v in ipairs(goalCard) do
			local _isExist = MatchConditionCtrl:isHaveImmune(v, immuneType)
			if _isExist then
				print("MatchConditionCtrl:异常状态免疫了")
			else
				local chance = MatchFunction:getPSFinalChance(data.effmainparam, data.effect, card, v);
				if chance < _rand then
					print("MatchConditionCtrl:被动异常状态没有被随机到")
				else
					local _posx, _posy = MatchFunction:getMatchCardPosition(v);
					local isExist = false; -- 部分免疫buff存在
					if data.effect == E_Effect.EE_TreatmentSeal then
						--治疗封印
						MatchEffect:stopTreat(ccp(_posx, _posy))
					elseif data.effect == E_Effect.EE_ProbabilityPoison then
						--中毒
						MatchEffect:poisoned(ccp(_posx, _posy))
					elseif data.effect == E_Effect.EE_ProbabilityFire then
						--灼烧
						MatchEffect:fire(ccp(_posx, _posy))
					elseif data.effect == E_Effect.EE_ProbabilityGiddy then
						if v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_DemonGene) then
							v.m_pMatchAnomaly:cleanOnceAnomalyByType(E_Anomaly.EA_DemonGene);
							isExist = true;
						elseif v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_AbuSoleutParticle) then
							isExist = true
						elseif v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_NewRallyOfRebirth) then
							--新生代集结buff的其他新生代角色是否拥有 免疫<眩晕> 效果，由此buff的主数值决定
							isExist = v.m_pMatchAnomaly:checkNewRallyOfRebirthImmune()
							if not isExist then
								MatchEffect:giddy(ccp(_posx, _posy));
							end
						else
							--眩晕
							MatchEffect:giddy(ccp(_posx, _posy));
						end
					elseif data.effect == E_Effect.EE_ProbabilityChaos then
						if v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_DemonGene) then
							v.m_pMatchAnomaly:cleanOnceAnomalyByType(E_Anomaly.EA_DemonGene);
							isExist = true;
						else
							--混乱
							MatchEffect:chaos(ccp(_posx, _posy));
						end
					elseif data.effect == E_Effect.EE_ProbabilityStopSkill then
						--封技
						MatchEffect:stopSkill(ccp(_posx, _posy));
					end
					if not isExist then
						v.m_pMatchAnomaly:setAnomalyByType(anomalyData[1], anomalyData[2], anomalyData[3], false);
						v.m_pMatchCardCCBI:addBuff(anomalyData[1], true);
						-- v:showWenZi(data.effect, anomalyData[3]);
						v.m_pMatchCardCCBI:updateAnomalyShow();
					end
				end
			end
		end
	end
end

--被动效果处理
local function onEffect( card, data, goalCard )
	-- body
	print("card.m_nAttackCount=",card.m_pMatchCardData.m_nAttackCount, "    data.effect=",data.effect)
	local Anomalyid = 0;
	if data.effect == E_Effect.EE_Initiative then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TriggerSkill, data.effoffparam, MatchFunction:match_round(data.effmainparam), false, nil, data.passiveid, data.passive_condition, nil, data.conditionparam);
		Anomalyid = E_Anomaly.EA_TriggerSkill;
		return;
	elseif data.effect == E_Effect.EE_LifeAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_LifeAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_LifeAdd;
	elseif data.effect == E_Effect.EE_AttackAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_AttackAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_AttackAdd;
	elseif data.effect == E_Effect.EE_PhysicalDefAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PhysicalDefAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PhysicalDefAdd;
	elseif data.effect == E_Effect.EE_SpecialDefAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpecialDefAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SpecialDefAdd;

	elseif data.effect == E_Effect.EE_FinalDamage then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_FinalDamage, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_FinalDamage;
		goalCard = nil;	--"最终伤害"的buff是添加在card上，而不是goalCard上，所以goalCard不需要显示“最终伤害”增加的文字
	elseif data.effect == E_Effect.EE_InjuryFree then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_InjuryFree, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_InjuryFree;

	elseif data.effect == E_Effect.EE_CritRateAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_CritRateAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CritRateAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CritRateAdd;
		goalCard = nil;
		
	elseif data.effect == E_Effect.EE_CritRateAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CritRateAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CritRateAddNotDispel;
		goalCard = nil;	
	
	elseif data.effect == E_Effect.EE_CritDamageAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_CritDamageAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CritDamageAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CritDamageAdd;

	elseif data.effect == E_Effect.EE_CritDamageAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CritDamageAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CritDamageAddNotDispel;
		
	elseif data.effect == E_Effect.EE_AntiknockCritAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_AntiknockCritAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_AntiknockCritAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_AntiknockCritAdd;

	elseif data.effect == E_Effect.EE_HitRateAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_HitRateAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_HitRateAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_HitRateAdd;
	
	elseif data.effect == E_Effect.EE_HitRateAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_HitRateAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_HitRateAddNotDispel;

	elseif data.effect == E_Effect.EE_DodgeRateAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_DodgeRateAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DodgeRateAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DodgeRateAdd;
		
	elseif data.effect == E_Effect.EE_DodgeRateAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DodgeRateAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DodgeRateAddNotDispel;

	elseif data.effect == E_Effect.EE_BlockRateAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_BlockRateAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_BlockRateAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_BlockRateAdd;
		
	elseif data.effect == E_Effect.EE_BlockRateAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_BlockRateAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_BlockRateAddNotDispel;
		
	elseif data.effect == E_Effect.EE_BrokenBlockRateAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_BlockRateAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_BrokenBlockRateAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_BrokenBlockRateAdd;
		
	elseif data.effect == E_Effect.EE_BrokenBlockRateAddNotDispel then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_BrokenBlockRateAddNotDispel, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_BrokenBlockRateAddNotDispel;

	elseif data.effect == E_Effect.EE_DamageFreeAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DamageFreeAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DamageFreeAdd;

	elseif data.effect == E_Effect.EE_PhysicalFreeAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PhysicalFreeAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PhysicalFreeAdd;

	elseif data.effect == E_Effect.EE_SpecialFreeAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpecialFreeAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SpecialFreeAdd;

	elseif data.effect == E_Effect.EE_AllDamageAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_AllDamageAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_AllDamageAdd, data.effoffparam, data.effmainparam, false);		
		Anomalyid = E_Anomaly.EA_AllDamageAdd;

	elseif data.effect == E_Effect.EE_PhysicalDamageAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PhysicalDamageAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PhysicalDamageAdd;

	elseif data.effect == E_Effect.EE_SpecialDamageAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpecialDamageAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SpecialDamageAdd;
		goalCard = nil;	--"特伤加值"的buff是添加在card上，而不是goalCard上，所以goalCard不需要显示“特伤 +%d”的文字
	elseif data.effect == E_Effect.EE_TreatmentAdd then
		if card.m_pMatchAnomaly:checkBuffImmuneByOther(E_Anomaly.EA_TreatmentAdd, data.effmainparam) then
			return
		end
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TreatmentAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_TreatmentAdd;

	elseif data.effect == E_Effect.EE_GiddyImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_GiddyImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_GiddyImmune;

	elseif data.effect == E_Effect.EE_ChaosImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_ChaosImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_ChaosImmune;

	elseif data.effect == E_Effect.EE_ReduceFuryImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_ReduceFuryImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_ReduceFuryImmune;

	elseif data.effect == E_Effect.EE_StopSkillImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_StopSkillImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_StopSkillImmune;

	elseif data.effect == E_Effect.EE_TreatmentSeal then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_ProbabilityPoison then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_ProbabilityFire then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_ProbabilityGiddy then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_ProbabilityChaos then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_ProbabilityStopSkill then
		ProbabilityHandle(card, data, goalCard);
		return;
	elseif data.effect == E_Effect.EE_CampDamage then

	elseif data.effect == E_Effect.EE_CampLife then

	elseif data.effect == E_Effect.EE_CampDefense then

	elseif data.effect == E_Effect.EE_RelieveAnomaly then
		-- card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_RelieveAnomaly, data.effoffparam, data.effmainparam, false);
		-- Anomalyid = E_Anomaly.EA_RelieveAnomaly;

		--随机选择友军
		-- local randomCard = MatchConditionCtrl:getRandomCard(card);
		-- print("jm -------------------------- card index: ", card:getMatchCardData():getIndexSole())
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local team = matchCardCtrl:getTeam(teamType);
		-- CCLog("MatchConditionCtrl cleanAnomalyByRandom indexSole:%d", randomCard:getMatchCardData():getIndexSole());
		-- 查询此时有异常buff的卡
		-- dump(team)
		local count = 1
		local types = nil
		local tempCards = {}
		for k,v in pairs(team) do
			if v.m_pMatchAnomaly ~= nil then
				-- print("jm -------------------------- card index: ", v:getMatchCardData():getIndexSole())
				count, types = v.m_pMatchAnomaly:getCurNegativeAnomalyType()
				-- print("@@@@@@@@@@@@@@@@@@@@@@@@@@@###################################")
				-- dump(types)
				-- print("jm -------------------------- v.m_pMatchAnomaly:getCurNegativeAnomalyType(): ", v:getMatchCardData():getIndexSole(), count, types)
				if count >= 1 then
					table.insert(tempCards, v)
				end
			end
		end
		-- local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local validCards = matchCardCtrl:getVaildCards(tempCards);
		-- if #validCards == 1 then
		-- 	validCards[1].m_pMatchAnomaly:cleanAnomalyByRandom(data.effmainparam);
		-- 	validCards[1].m_pMatchCardCCBI:updateAnomalyBuffArmature();
		-- 	validCards[1].m_pMatchCardCCBI:updateAnomalyShow();
		-- 	CCLog("jm ---------------------- indexSole:%d", validCards[1]:getMatchCardData():getIndexSole());
		-- elseif #validCards > 1 then
		-- 	math.randomseed(os.time());
		-- 	local index = math.random(1, count)
		-- 	validCards[index].m_pMatchAnomaly:cleanAnomalyByRandom(data.effmainparam);
		-- 	validCards[index].m_pMatchCardCCBI:updateAnomalyBuffArmature();
		-- 	validCards[index].m_pMatchCardCCBI:updateAnomalyShow();
		-- 	CCLog("jm ---------------------- indexSole:%d", validCards[index]:getMatchCardData():getIndexSole());
		-- end

		if #validCards > 0 then
			for i,v in ipairs(validCards) do
				v.m_pMatchAnomaly:cleanAnomalyByRandom(data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyBuffArmature();
				v:showWenZi(data.effect, data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyShow();
			end
		end

		-- --随机解除异常
		-- randomCard.m_pMatchAnomaly:cleanAnomalyByRandom(data.effmainparam);
		
		-- --重新刷新
		-- randomCard.m_pMatchCardCCBI:updateAnomalyBuffArmature();
		-- randomCard.m_pMatchCardCCBI:updateAnomalyShow();
		return;
	elseif data.effect == E_Effect.EE_PowerAdd then
		if data.effmainparam < 0 then
			local _isExist = MatchConditionCtrl:isHaveImmune(card, E_IMMUNE.EI_ReduceFuryImmune)
			if _isExist then
				print("MatchConditionCtrl:减能免疫")
			else
				card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PowerAdd, data.effoffparam, data.effmainparam, false);
				Anomalyid = E_Anomaly.EA_PowerAdd;
			end
		else
			card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PowerAdd, data.effoffparam, data.effmainparam, false);
			Anomalyid = E_Anomaly.EA_PowerAdd;
		end
	elseif data.effect == E_Effect.EE_FireImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_FireImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_FireImmune;
	elseif data.effect == E_Effect.EE_PoisonImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PoisonImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PoisonImmune;
	elseif data.effect == E_Effect.EE_CritDamageFreeAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CritDamageFreeAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CritDamageFreeAdd;
	elseif data.effect == E_Effect.EE_PowerSkillBuffer then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PowerSkillBuffer, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PowerSkillBuffer;
	elseif data.effect == E_Effect.EE_Revive then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Revive, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_Revive;
	elseif data.effect == E_Effect.EE_FeignDeath then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_FeignDeath;
	elseif data.effect == E_Effect.EE_RemoveAnomaly then
		local id = MatchConditionCtrl:changeType(data.effmainparam)
		if id ~= E_Anomaly.EA_EndMark then
			card.m_pMatchAnomaly:cleanAnomalyByType(id)
			print("E_Effect.EE_RemoveAnomaly: ", id, card.m_pMatchCardData:getIndexSole())
			if id == E_BUFFID.EBI_Doll then
				card.m_pMatchCardCCBI:getCCBI():setScale(1)
				card.m_pMatchCardCCBI:getShadow():setScale(1)
				card.m_pMatchCardCCBI:refreshShadow()
			end
			card.m_pMatchCardCCBI:updateAnomalyBuffArmature();
			card.m_pMatchCardCCBI:updateAnomalyShow();
		else
			local teamType = card:getMatchCardData():getTeam();
			local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
			local atkTeamCards = matchCardCtrl:getTeam(teamType);
			local enemyTeamCards;

			if teamType == E_MATCH.TEAM_MY then
				enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_OPPO);
			else
				enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_MY);
			end

			local validCards = matchCardCtrl:getVaildCards(enemyTeamCards);
			for i,v in pairs(validCards) do
				if v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_EndMark) then
					print("清除印记")
					v.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_EndMark);
					v.m_pMatchCardCCBI:updateAnomalyBuffArmature();
					v.m_pMatchCardCCBI:updateAnomalyShow();
					break;
				end
			end
		end
	elseif data.effect == E_Effect.EE_RelieveDebuff then
		-- card.m_pMatchAnomaly:cleanDebuffByRandom( data.effmainparam )
		-- card:showWenZi(data.effect);
		-- card.m_pMatchCardCCBI:updateAnomalyBuffArmature();
		-- card.m_pMatchCardCCBI:updateAnomalyShow();
		-- dump(card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_RaiseHurt))

		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local team = matchCardCtrl:getTeam(teamType);
		-- 查询此时有异常buff的卡
		local count = 1
		local types = nil
		local status = nil
		local tempCards = {}
		for k,v in pairs(team) do
			if v.m_pMatchAnomaly ~= nil then
				-- print("jm -------------------------- card index: ", v:getMatchCardData():getIndexSole())
				count, types, status = v.m_pMatchAnomaly:getCurDebuffAnomalyType()
				-- print("@@@@@@@@@@@@@@@@@@@@@@@@@@@###################################")
				-- dump(types)
				-- print("jm -------------------------- v.m_pMatchAnomaly:getCurNegativeAnomalyType(): ", v:getMatchCardData():getIndexSole(), count, types)
				if count >= 1 then
					table.insert(tempCards, v)
				end
			end
		end
		local validCards = matchCardCtrl:getVaildCards(tempCards);
		if #validCards > 0 then
			for i,v in ipairs(validCards) do
				v.m_pMatchAnomaly:cleanDebuffByRandom(data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyBuffArmature();
				v:showWenZi(data.effect, data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyShow();
			end
		end
		return
	elseif data.effect == E_Effect.EE_Transform then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Transform, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_Transform;
	elseif data.effect == E_Effect.EE_SpecialBuff then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpecialBuff, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SpecialBuff;
	elseif data.effect == E_Effect.EE_HPMaxPerDamage then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_HPMaxPerDamage, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_HPMaxPerDamage;
	elseif data.effect == E_Effect.EE_PhysicalImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PhysicalImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PhysicalImmune;
	elseif data.effect == E_Effect.EE_SpecialImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpecialImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SpecialImmune;
	elseif data.effect == E_Effect.EE_TreatmentSealImmune then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TreatmentSealImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_TreatmentSealImmune;
	elseif data.effect == E_Effect.EE_DamageTransform then
		--一次受击多个队友受致命伤时，只庇护一个
		if card:getMatchCardData():getIsDamageTransform() == true  then
			return
		end
		local indexSole = card:getMatchCardData():getIndexSole()
		local cid = card:getMatchCardData():getCID()
		goalCard.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DamageTransfer, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid);
		Anomalyid = E_Anomaly.EA_DamageTransfer;
		
		card.m_pMatchCardSkill:reduceTimes(data.passiveid, 1);
		card.m_pMatchCardSkill:reduceTimes(data.passiveid, 2);
		-- if data.passive_condition == E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE_TEAMMATE then
			card:getMatchCardData():setIsDamageTransform(true);
			goalCard:getMatchCardData():setIsDamageTransformByTeammate(true);
		-- end

		--界面刷新
		-- MatchFunction:updateEffect(goalCard, E_Anomaly.EA_DamageTransfer)

		--显示文字效果
		local _posx, _posy =  MatchFunction:getMatchCardPosition(goalCard )
		MatchEffect:damageTransfer(ccp(_posx, _posy))
		MatchCtrl:getInstance():setIsDamageTransform(true)
		--重新runEffect1放到matchstepmidharm中执行
		-- MatchCtrl:getInstance():getMatchStepMid():runEffect1()
	elseif data.effect == E_Effect.EE_DotAdd then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DotAdd, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DotAdd;
	elseif data.effect == E_Effect.EE_MyTeamAura then
		goalCard.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_MyTeamAura, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, nil,card:getMatchCardData():getSID());
		goalCard.m_pMatchCardCCBI:addBuff(E_Anomaly.EA_MyTeamAura, true);
		-- goalCard:showWenZi(data.effect);
		goalCard.m_pMatchCardCCBI:updateAnomalyShow();
	elseif data.effect == E_Effect.EE_Nibble then
		local countAdd = 1
		if goalCard ~= nil then
			countAdd = goalCard.m_pMatchAnomaly:getCurNegativeAnomalyType() + goalCard.m_pMatchAnomaly:getCurDebuffAnomalyType();
		end
		local curCount = card.m_pMatchAnomaly:getDataAddByType(E_Anomaly.EA_Nibble);
		if countAdd > 0 then
			if data.effmainparam < 0 then
				if countAdd * data.effmainparam + curCount >= 0 then
					card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Nibble, data.effoffparam, data.effmainparam * countAdd, false, 0.05);

					local iHpMax = card:getMatchCardData():getHPMax();
					local iCurHp = card:getMatchCardData():getHP();
					local iBuffer = MatchFunction:match_round(iHpMax - iCurHp);
					if iBuffer <= 0 then
						return;
					end
					card:setHP(iBuffer);
					--记录伤害
					local _ptrGroupCard = {
											m_pCard = card,
											m_pAtkCard = card,
										  };
					MatchStepMidAnimHit:record(_ptrGroupCard, iBuffer);
					--显示文字
					local _posx, _posy = MatchFunction:getMatchCardPosition(card);
					MatchEffect:recover_small(ccp(_posx, _posy), iBuffer);
					MatchEffect:nibble(ccp(_posx, _posy), data.effmainparam * countAdd);
					MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole());
				end
			else
				local _posx, _posy = MatchFunction:getMatchCardPosition(card);
				if countAdd * data.effmainparam + curCount > 10 then
					card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Nibble, data.effoffparam, 10 - curCount, false, 0.05);
					MatchEffect:nibble(ccp(_posx, _posy), 10 - curCount);
				else
					card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Nibble, data.effoffparam, data.effmainparam * countAdd, false, 0.05);
					MatchEffect:nibble(ccp(_posx, _posy), data.effmainparam * countAdd);
				end	
			end	
		end
	elseif data.effect == E_Effect.EE_Delay then
		local randIndex = 1;
		for k,v in pairs(goalCard) do
			local chance = data.effmainparam
			local cardInfoCid = get_st_cardindex_value(v.m_pMatchCardForm:getUniqueid(), "cid")						
			local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");
			if _factionId == 1 then
				--奥特曼概率增加
				chance = chance + data.effoffparam
			end

			math.randomseed(tostring(os.time()):reverse():sub(1, 6)+randIndex*123) 
			local rand = math.random(1,100)
			print("EE_Delay chance,rand",chance,rand)
			if rand <= chance then
				--延迟buff
				v.m_pMatchAnomaly:delayCurBuffAnomaly();

				v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Delay, 15, chance, false);
				local _posx, _posy = MatchFunction:getMatchCardPosition(v);
				MatchEffect:delay(ccp(_posx, _posy));
				v.m_pMatchCardCCBI:updateAnomalyShow();
			end
			randIndex = randIndex + 1;
		end
		return
	elseif data.effect == E_Effect.EE_Regain then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();

		local enemyTeamCards;
		if teamType == E_MATCH.TEAM_MY then
			enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_OPPO);
		else
			enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_MY);
		end
		for k,v in pairs(enemyTeamCards) do
			if v:getMatchCardData():getIsVaild() == true then
				if v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Delay) then
					--还原buff
					v.m_pMatchAnomaly:regainCurBuffAnomaly();
					v.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_Delay)
				end
			end
		end
		return
	elseif data.effect == E_Effect.EE_PercentAtk then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PercentAtk, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PercentAtk;
	elseif data.effect == E_Effect.EE_DamageTeamFreeAdd then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local team = matchCardCtrl:getTeam(teamType);
		local validCards = matchCardCtrl:getVaildCards(team);
		if #validCards > 0 then
			for i,v in ipairs(validCards) do
				v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DamageFreeAdd, data.effoffparam, data.effmainparam, false);
				v.m_pMatchCardCCBI:addBuff(E_Anomaly.EA_DamageFreeAdd, true);
				v:showWenZi(data.effect, data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyShow();
			end
		end
		return
	elseif data.effect == E_Effect.EE_EndMark then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local atkTeamCards = matchCardCtrl:getTeam(teamType);
		local enemyTeamCards;
		if teamType == E_MATCH.TEAM_MY then
			enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_OPPO);
		else
			enemyTeamCards = matchCardCtrl:getTeam(E_MATCH.TEAM_MY);
		end
		--获取目标
		local index = card:getMatchCardData():getIndex()
		local ptrCards = MatchFormation:create( index, data.conditionparam, enemyTeamCards, atkTeamCards) or {}
		for i,v in pairs(ptrCards) do
			MatchCtrl:getInstance():setEndMarkLimitHarm(card:getMatchCardData():getHPMax());
			v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_EndMark, data.effoffparam, data.effmainparam, false);
			v.m_pMatchCardCCBI:addBuff(E_Anomaly.EA_EndMark, true);
			v:showWenZi(data.effect);
			v.m_pMatchCardCCBI:updateAnomalyShow();
		end
		return
	elseif data.effect == E_Effect.EE_ReviveSameFaction then
		local _table = {}
		for k1,v1 in pairs(goalCard) do
			print("阵营1",get_st_bcardinfo_value(v1:getMatchCardData():getCID(), "faction"))
			print("阵营1cid",v1:getMatchCardData():getCID())
			-- print("阵营2",get_st_bcardinfo_value(card:getMatchCardData():getCID(), "faction"))
			-- if get_st_bcardinfo_value(v1:getMatchCardData():getCID(), "faction") == get_st_bcardinfo_value(card:getMatchCardData():getCID(), "faction") then
			if get_st_bcardinfo_value(v1:getMatchCardData():getCID(), "faction") == 2 or get_st_bcardinfo_value(v1:getMatchCardData():getCID(), "faction") == 3 then
				--将复活同阵营 改为 复活怪兽或宇宙人 2020 5 26
				print("table.insert")
				table.insert(_table,v1)
			end
		end
		print("#_table",#_table)
		if #_table > 0 then
			math.randomseed(tostring(os.time()):reverse():sub(1, 6))
			local rand = math.random(1, #_table);

			local function reviveAfterDie( ... )
				--异常
				local _matchAnomaly = _table[rand]:getMatchAnomaly()
				if _matchAnomaly then
					_matchAnomaly:cleanAnomaly()
				end	
				--消除异常显示
				_table[rand].m_pMatchCardCCBI:cleanAnomalyBuffArmature()
				_table[rand].m_pMatchCardCCBI:updateAnomalyShow()
				--重置数据
				local _matchCardData = _table[rand]:getMatchCardData()
				_matchCardData:resetAttackCount()
				_matchCardData:resetAttackedCount()
				_matchCardData:resetTargetedCount()
				_matchCardData:resetNorAttackCount()
				_matchCardData:setHP(_table[rand]:getMatchCardData():getHPMax()/2)
				_table[rand].m_pMatchCardCCBI:refreshHP()
				_table[rand].m_pMatchCardCCBI:setIsBlink_HP()
				_table[rand].m_pMatchCardDie.m_bIsEndAnimDie = false;
				_table[rand].m_pMatchCardDie.m_bIsAnimDie = false;
				_table[rand].m_pMatchCardDie.m_bPSConditionFlag_die = false;
				local _cur = _matchCardData:getFury()
				local _init = _matchCardData:getFuryInit()
				_table[rand]:setFury(_init - _cur)
				_table[rand]:getMatchCardCCBI():liveAgain();
			end
			if _table[rand]:getMatchCardDie():getIsEndAnimDie() == true then
				reviveAfterDie()
			else
				_table[rand]:getMatchCardDie():setDieAnimCallback1(reviveAfterDie)
			end
		else
			-- 自己回满血
			print("回血回血")
			local iHpMax = card:getMatchCardData():getHPMax();
			local iCurHp = card:getMatchCardData():getHP();
			local iBuffer = MatchFunction:match_round(iHpMax - iCurHp);
			if iBuffer <= 0 then
				return;
			end
			card:setHP(iBuffer);
			--记录伤害
			local _ptrGroupCard = {
									m_pCard = card,
									m_pAtkCard = card,
								  };
			MatchStepMidAnimHit:record(_ptrGroupCard, iBuffer);
			--显示文字
			local _posx, _posy = MatchFunction:getMatchCardPosition(card);
			MatchEffect:recover_small(ccp(_posx, _posy), iBuffer);
			MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole());
		end
		return
	elseif data.effect == E_Effect.EE_EssenceMercyMark then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_EssenceMercyMark, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_EssenceMercyMark;
	elseif data.effect == E_Effect.EE_EssenceEvilMark then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_EssenceEvilMark, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_EssenceEvilMark;
	elseif data.effect == E_Effect.EE_SupportOfForce then
		goalCard.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SupportOfForce, data.effoffparam, data.effmainparam, false, card:getMatchCardData():getIndexSole());
		goalCard:showWenZi(data.effect, data.effmainparam);
		goalCard.m_pMatchCardCCBI:updateAnomalyShow();
		Anomalyid = E_Anomaly.EA_SupportOfForce;
	elseif data.effect == E_Effect.EE_MindLinking then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCards(matchCardCtrl:getTeam(teamType));
		for k,v in pairs(selfTeamCards) do
			v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_MindLinking, data.effoffparam, data.effmainparam, false);
			v.m_pMatchCardCCBI:updateAnomalyShow();
		end
		Anomalyid = E_Anomaly.EA_MindLinking;
	elseif data.effect == E_Effect.EE_CreationShield then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_CreationShield, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_CreationShield;
	elseif data.effect == E_Effect.EE_PercentPhysicalDef then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PercentPhysicalDef, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PercentPhysicalDef;
	elseif data.effect == E_Effect.EE_PercentSpecialDef then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_PercentSpecialDef, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_PercentSpecialDef;
	elseif data.effect == E_Effect.EE_DarkForce then
		local effect = 5; --被动技能表的限制，效果就写死在这里了
		local darkForce = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_DarkForce);
		local curCount = (darkForce and #darkForce) or 0;

		if data.effmainparam < 0 then
			if data.effmainparam + curCount >= 0 then
				for i=1,math.abs(data.effmainparam) do
					table.remove(darkForce);
				end

				local iHpMax = card:getMatchCardData():getHPMax();
				local iCurHp = card:getMatchCardData():getHP();
				local iBuffer = MatchFunction:match_round(iHpMax - iCurHp);
				if iBuffer <= 0 then
					return;
				end
				card:setHP(iBuffer);
				card:getMatchAnomaly():cleanAllDebuffAndAnomaly()
				--记录伤害
				local _ptrGroupCard = {
										m_pCard = card,
										m_pAtkCard = card,
									  };
				MatchStepMidAnimHit:record(_ptrGroupCard, iBuffer);
				--显示文字
				local _posx, _posy = MatchFunction:getMatchCardPosition(card);
				MatchEffect:recover_small(ccp(_posx, _posy), iBuffer);
				-- MatchEffect:nibble(ccp(_posx, _posy), data.effmainparam * countAdd);
				MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole());
			end
		else
			-- 暗黑原力只能叠加10层
			if curCount < 10 then
				local count = data.effmainparam;
				for i=1,count do
					card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DarkForce, data.effoffparam, effect, false);
				end
				Anomalyid = E_Anomaly.EA_DarkForce;
			elseif curCount >= 10 and not card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_DarkForceMaxValue) then
				card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DarkForceMaxValue, 10, effect * 10, false);
			else
				return
			end
		end	
	elseif data.effect == E_Effect.EE_EvilTemptation then
		if data.effmainparam ~= 0 then
			-- 没有被控制时可发
			if not card.m_pMatchAnomaly:isAnomalyByTypeList(E_Anomaly.EA_Giddy,E_Anomaly.EA_Imprison,E_Anomaly.EA_Gemize, E_Anomaly.EA_Exile, E_Anomaly.EA_Frost) then 
				data.effect = E_Effect.EE_Initiative;
				onEffect(card,data);
			end
			return
		end

		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local matchNetwork = MatchCtrl:getInstance():getMatchNetwork();

		local originCardData = {};
		if teamType == E_MATCH.TEAM_MY then
			originCardData = matchNetwork:getNetworkData_my()
		elseif teamType == E_MATCH.TEAM_OPPO then
			local _battleIndex = MatchCtrl:getInstance():getMatchBattleCtrl():getBattleIndex()
			originCardData = matchNetwork:getNetworkData_oppo(_battleIndex)
		end

		local function getRealIndex(targetCard)
			if targetCard:getMatchCardData():getSubsIdex() >= 7 then
				return targetCard:getMatchCardData():getSubsIdex()
			else
				-- 检测是否被换过位子
				if targetCard:getMatchCardData().m_IsChangedPos then
					for i,v in ipairs(matchCardCtrl:getTeam(teamType)) do
						if v:getMatchCardData().m_IsChangedPos and v:getMatchCardData():getCID() ~= targetCard:getMatchCardData():getCID() then
							return v:getMatchCardData():getIndex();
						end
					end
				else
					return targetCard:getMatchCardData():getIndex();
				end
			end
		end
		local target = nil;
		for k,v in pairs(selfTeamCards) do
			if target == nil then
				target = v;
			else
				local curCard = originCardData[getRealIndex(target)];
				local newCard = originCardData[getRealIndex(v)];
				if newCard.finalAttack > curCard.finalAttack then
					target = v;
				end
			end
		end
		matchCardCtrl:registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_EvilTemptation, teamType);
		target.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_EvilTemptation, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, nil,card:getMatchCardData():getSID());
		Anomalyid = E_Anomaly.EA_EvilTemptation;
		target:showWenZi(data.effect, data.effmainparam);
		target.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
		target.m_pMatchCardCCBI:updateAnomalyShow();
	elseif data.effect == E_Effect.EE_SkillPowerUp then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SkillPowerUp, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_SkillPowerUp;
	elseif data.effect == E_Effect.EE_DamageFreePercent then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DamageFreePercent, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DamageFreePercent;
	elseif data.effect == E_Effect.EE_RedSteelForce then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_RedSteelForce, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_RedSteelForce;
	elseif data.effect == E_Effect.EE_UltimateForce then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_UltimateForce, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_UltimateForce;
	elseif data.effect == E_Effect.EE_DataHacking then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local targetCard = nil;
		local maxAtkCard = nil;
		for k,v in ipairs(selfTeamCards) do
			--数据侵入不能叠加
			if not v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_DataHacking) then
				--优先被数据化的目标
				if v.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Dataize) then
					targetCard = v;
					break;
				end
				if maxAtkCard ~= nil then
					if v:getMatchCardDataAdd():getAttack() > maxAtkCard:getMatchCardDataAdd():getAttack() then
						maxAtkCard = v
					end
				else
					maxAtkCard = v
				end
			end
		end
		if not targetCard then 
			if not maxAtkCard then
				maxAtkCard = MatchFormation:maxAtkAdd( selfTeamCards )[1];
			end
			targetCard = maxAtkCard;
		end

		targetCard.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_DataHacking);
		targetCard.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DataHacking, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DataHacking;
		targetCard.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
		targetCard:showWenZi(data.effect, data.effmainparam);
		targetCard.m_pMatchCardCCBI:updateAnomalyShow();
	elseif data.effect == E_Effect.EE_TriPower then
		local anomaly = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_TriPower);
		if not anomaly or #anomaly < 3 then 
			card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TriPower, data.effoffparam, data.effmainparam, false);
			Anomalyid = E_Anomaly.EA_TriPower;
		end
		if anomaly and #anomaly >= 3 then
			data.effect = E_Effect.EE_Initiative;
			data.effmainparam = data.conditionparam; -- 条件参数用作触发技id
			onEffect(card,data);
			return
		end
	elseif data.effect == E_Effect.EE_DoubleDefPer then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DoubleDefPer, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DoubleDefPer;
	elseif data.effect == E_Effect.EE_LifeLink then
		--替补时不生效
		if card:getMatchCardData():getSubsIdex() ~= 0 then
			return
		end
		local index = card:getMatchCardData():getIndex();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local teamType = card:getMatchCardData():getTeam();
		-- 只在前排时生效，且后排有人时生效
		if index > E_MATCH.CONST_LINE_MAX then
			return
		end
		local targetCard = matchCardCtrl:getTeam(teamType)[index + E_MATCH.CONST_LINE_MAX];
		if not targetCard:getMatchCardData():getIsVaild() then
			return
		end

		matchCardCtrl:registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_LifeLink, teamType);
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_LifeLink, data.effoffparam, data.effmainparam, false, targetCard:getMatchCardData():getIndexSole());
		targetCard.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_LifeLink, data.effoffparam, data.effmainparam, false, card:getMatchCardData():getIndexSole(), nil, nil, nil, nil,card:getMatchCardData():getSID());
		Anomalyid = E_Anomaly.EA_LifeLink;
	elseif data.effect == E_Effect.EE_GigaBattleNizer then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_GigaBattleNizer, data.effoffparam, data.effmainparam, false,nil,nil,nil,nil,data.conditionparam);
		Anomalyid = E_Anomaly.EA_GigaBattleNizer;
	elseif data.effect == E_Effect.EE_DemonGene then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DemonGene, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_DemonGene;
	elseif data.effect == E_Effect.EE_ResentmentErosion then
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local target = MatchFormation:maxHP( matchCardCtrl:getOppoTeam(card:getMatchCardData():getTeam()) )[1];
		matchCardCtrl:registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_ResentmentErosion, target:getMatchCardData():getTeam());
		target.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_ResentmentErosion, data.effoffparam, data.effmainparam, false,card:getMatchCardData():getIndexSole(),nil, nil, nil, 1, card:getMatchCardData():getSID());
		card:getMatchCardData().m_iSaveAttack = card:getMatchCardDataAdd():getAttack();
		target.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
		target:showWenZi(data.effect);
		target.m_pMatchCardCCBI:updateAnomalyShow();
		Anomalyid = E_Anomaly.EA_ResentmentErosion;
	elseif data.effect == E_Effect.EE_AbsorbAtk then
		local addPer = data.effmainparam * 0.01;
		local maxAtk = data.conditionparam * card:getMatchCardData():getAttack() * 0.01;
		data.effmainparam = 0;
		local allMember = MatchCtrl:getInstance():getMatchCardCtrl():getAllCards();
		for i,v in ipairs(allMember) do
			if v:getMatchCardData():getIsVaild() then
				local atk = v:getMatchCardData():getAttack();
				data.effmainparam = data.effmainparam + atk*addPer;
			end
		end
		data.effmainparam = ((data.effmainparam > maxAtk) and maxAtk) or data.effmainparam;
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_AbsorbAtk, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_AbsorbAtk;
	elseif data.effect == E_Effect.EE_DarkField then  --邪神黑暗领域
		if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_DarkField) then
			local teamType = card:getMatchCardData():getTeam();
			local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
			local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
			local indexSole = card:getMatchCardData():getIndexSole()
			local sid = card:getMatchCardData():getSID()
			local cid = card:getMatchCardData():getCID()
			matchCardCtrl:registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_DarkField, teamType);
			Anomalyid = E_Anomaly.EA_DarkField;
			for i,v in ipairs(selfTeamCards) do
				local faction = get_st_bcardinfo_value(v:getMatchCardData():getCID(), "faction");
				if faction == 2 or faction == 3 or faction == 4 then
					--mark: 用于技伤增幅/技伤减免
					--condition_param: 用于对格里姆德 的毒烧伤害
					v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_DarkField, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, 0, sid);
					v.m_pMatchCardCCBI:addBuff(Anomalyid);
					v:showWenZi(data.effect, data.effmainparam);
					v.m_pMatchCardCCBI:updateAnomalyShow();
				end
			end
			if card:getMatchCardSkill():addPSkillID(979) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(979)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_DEAD then
			--已经有再触发就说明是死亡复活逻辑
			local teamType = card:getMatchCardData():getTeam();
			local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
			local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
			local tregear = nil;
			for i,v in ipairs(selfTeamCards) do
				local uid = v.m_pMatchCardForm:getUniqueid();
				if uid == 348 then
					tregear = v;
					break;
				end
			end
			local iBuffer = 0;
			local iCurHp = card:getMatchCardData():getHP();
			if tregear and card:getMatchCardData().m_bIsGrimdoRevive_2 then
				card:getMatchCardData().m_bIsGrimdoRevive_2 = false;
				iBuffer = MatchFunction:match_round(tregear:getMatchCardData():getHP() * 0.5);
				tregear:setHP(-iBuffer);
				--记录伤害
				local _ptrGroupCard = {
										m_pCard = tregear,
									  };
				MatchStepMidAnimHit:record(_ptrGroupCard, -iBuffer);
				--显示文字
				local _posx, _posy = MatchFunction:getMatchCardPosition(tregear);
				MatchEffect:hp(ccp(_posx, _posy), -iBuffer);
				iBuffer = iBuffer - iCurHp;
			elseif card:getMatchCardData().m_bIsGrimdoRevive_1 then
				card:getMatchCardData().m_bIsGrimdoRevive_1 = false;
				local iHpMax = card:getMatchCardData():getHPMax();
				iBuffer = MatchFunction:match_round(iHpMax*data.effmainparam*0.01 - iCurHp);
			else
				return
			end
			if iBuffer <= 0 then
				return;
			end
			card:setHP(iBuffer);
			--记录伤害
			local _ptrGroupCard = {
									m_pCard = card,
									m_pAtkCard = card,
								  };
			MatchStepMidAnimHit:record(_ptrGroupCard, iBuffer);
			--显示文字
			local _posx, _posy = MatchFunction:getMatchCardPosition(card);
			MatchEffect:recover_small(ccp(_posx, _posy), iBuffer);
			MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole());
			card.m_pMatchCardCCBI:refreshHP(function() end)
			
		elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_DEAD_CAMP_JUDGE then
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_DarkFieldExt, data.effoffparam, data.effmainparam, false)
		end
		
		return
	elseif data.effect == E_Effect.EE_Possessed then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local target = nil;
		for i,v in ipairs(selfTeamCards) do
			--if v:getMatchCardData():getCID() ~= card:getMatchCardData():getCID() then
				local uid = v.m_pMatchCardForm:getUniqueid();
				if uid == 348 then
					target = v;
					break;
				end
				if target == nil then
					target = v;
				else
					if v:getMatchCardDataAdd():getAttack() > target:getMatchCardDataAdd():getAttack() then
						target = v;
					end
				end
			--end
		end

		if target == nil then
			return;
		end

		local defense = card:getMatchCardData():getPhysDefense();
		local value = data.effmainparam * 0.01 * defense;
		card:getMatchCardData().m_pPossessed = target;
		local indexSole = card:getMatchCardData():getIndexSole()
		target.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Possessed, data.effoffparam, value, false, data.conditionparam, nil, nil, nil);
		target.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
		target:showWenZi(data.effect, data.effmainparam);
		target.m_pMatchCardCCBI:updateAnomalyShow();
		Anomalyid = E_Anomaly.EA_Possessed;
		return
	elseif data.effect == E_Effect.EE_Resonance then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local target = nil;
		for i,v in ipairs(selfTeamCards) do
			local uid = v.m_pMatchCardForm:getUniqueid();
			if uid == 348 then
				target = v;
				break;
			end
		end
		if not target then
			return
		end
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_Resonance, teamType);
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Resonance, data.effoffparam, data.effmainparam, false);
		target.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Resonance, data.effoffparam, data.effmainparam, false,card:getMatchCardData():getIndexSole(),nil, nil, nil, nil, card:getMatchCardData():getSID());

		card:getMatchCardData().m_pResonator,target:getMatchCardData().m_pResonator = target,card;
		target.m_pMatchCardCCBI:addBuff(Anomalyid);
		target:showWenZi(data.effect);
		target.m_pMatchCardCCBI:updateAnomalyShow();
		Anomalyid = E_Anomaly.EA_ResentmentErosion;
	elseif data.effect == E_Effect.EE_Awaking then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		if #selfTeamCards <= 0 then
			return
		end
		local target = nil;
		for i,v in ipairs(selfTeamCards) do
			if target == nil then
				target = v;
			else
				if target:getMatchCardDataAdd():getCritDamage() < v:getMatchCardDataAdd():getCritDamage() then
					target = v;
				end
			end
		end

		target.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Awaking, data.effoffparam, data.effmainparam, false,card:getMatchCardData():getIndexSole(),nil, nil, nil, data.conditionparam*0.01);

		Anomalyid = E_Anomaly.EA_Awaking;
		target.m_pMatchCardCCBI:addBuff(Anomalyid);
		target:showWenZi(data.effect);
		target.m_pMatchCardCCBI:updateAnomalyShow();
	elseif data.effect == E_Effect.EE_Reverse then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local baseValue = data.effmainparam;
		local addValue = data.conditionparam;
		local maxAddValueSelf = 40;
		local maxAddValueOther = 20;
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_Reverse, teamType);
		for i,v in ipairs(selfTeamCards) do
			local evasion = baseValue;
			local addEvasion = 0;
			if v:getMatchCardData():getCID() ~= card:getMatchCardData():getCID() then
				evasion = 5;
				addEvasion = math.floor(v:getMatchCardData():getEvasion()/2)*addValue;
				addEvasion = ((addEvasion < maxAddValueOther) and addEvasion) or maxAddValueOther;
			else
				addEvasion = math.floor(v:getMatchCardData():getEvasion())*addValue;
				addEvasion = ((addEvasion < maxAddValueSelf) and addEvasion) or maxAddValueSelf;
			end
			evasion = evasion + addEvasion;
			v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Reverse, data.effoffparam, evasion, false, card:getMatchCardData():getIndexSole(), nil, nil, nil, nil, card:getMatchCardData():getSID());
			Anomalyid = E_Anomaly.EA_Reverse;
			v.m_pMatchCardCCBI:addBuff(Anomalyid);
			v:showWenZi(data.effect);
			v.m_pMatchCardCCBI:updateAnomalyShow();
		end
	elseif data.effect == E_Effect.EE_ReviveAll then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamCards = matchCardCtrl:getTeam(teamType);

		-- -- 先清除自身所有buff
		-- card.m_pMatchAnomaly.m_Datas = {};
		-- card.m_pMatchAnomaly.m_AddDatas = {};
		-- card.m_pMatchAnomaly.m_DelayDatas = {};

		-- 复活队友
		for i,v in ipairs(selfTeamCards) do
			if v:getMatchCardData():getIsTeamMember() == true and v:getMatchCardData():getIsLive() == false then
				local _timerid = 0;
				local function checkRevive()
					if v:getMatchCardDie():getIsEndAnimDie() then
						CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(_timerid);
					else
						return
					end
					local index = v.m_pMatchCardData:getIndex()
					if v.m_pMatchCardData:getSubsIdex() >= 7 then
						index = v.m_pMatchCardData:getSubsIdex()
					end
					local newCardData = nil
					if teamType == E_MATCH.TEAM_MY then
						newCardData = DPF:copytable(MatchCtrl:getInstance():getMatchNetwork():getNetworkData_my()[index])
					elseif teamType == E_MATCH.TEAM_OPPO then
						local _battleIndex = MatchCtrl:getInstance():getMatchBattleCtrl():getBattleIndex()
						newCardData = DPF:copytable(MatchCtrl:getInstance():getMatchNetwork():getNetworkData_oppo( _battleIndex )[index])
					end
					newCardData.shield_finalHp = 0
					newCardData.isZeroRevive = true;
					v:init(newCardData)
					local _matchAppearInOutOne = MatchAppearInOutOne:new(v, E_MATCH.APPEAR_INOUT_IN1)
					_matchAppearInOutOne:appear()
				end

				_timerid = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(checkRevive,0.1,false);

				MatchLog:getInstance():locateCardMsgByIndexSole(v:getMatchCardData():getIndexSole());
				MatchLog:getInstance():setCardMsgInfo("effectType", EFFECTTYPE.REVIVEALL);
			end
		end
		card:showWenZi(data.effect);
		Anomalyid = E_Anomaly.EA_ReviveAll;
	elseif data.effect == E_Effect.EE_UltimateParaggi then
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_UltimateParaggi, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_UltimateParaggi;
	elseif data.effect == E_Effect.EE_ParaggiGuard then
		Anomalyid = E_Anomaly.EA_ParaggiGuard
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card.m_pMatchAnomaly:setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, data.conditionparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:showWenZi(data.effect)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(963) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(963)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].condition_param = data.effmainparam
		end
		return
	elseif data.effect == E_Effect.EE_UltimateLight then
		Anomalyid = E_Anomaly.EA_UltimateLight
		local addAnomalyBuff = function(nums)
			for i = 1, nums do
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			end
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:showWenZi(data.effect)
			card:getMatchCardCCBI():updateAnomalyShow()
		end
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			addAnomalyBuff(data.conditionparam)
			if card:getMatchCardSkill():addPSkillID(962) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(962)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local teamType = card:getMatchCardData():getTeam()
			local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
			local count = E_MATCH.CONST_MEMBER_MAX - #oppoCards			
			addAnomalyBuff(count)

			local specialDefcards, physicDefcards = {}, {}
			for k,v in pairs(oppoCards) do
				if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_SpecialDefense) then
					table.insert(specialDefcards, v)
				end
				if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Defense) then
					table.insert(physicDefcards, v)
				end
			end
			
			if #specialDefcards > 0 then
				math.randomseed(tostring(os.time()):reverse():sub(1, 6))
				local rand = math.random(1, #specialDefcards)
				specialDefcards[rand]:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_SpecialDefense)
				specialDefcards[rand]:getMatchCardCCBI():updateAnomalyShow()
			elseif #physicDefcards > 0 then
				math.randomseed(tostring(os.time()):reverse():sub(1, 6))
				local rand = math.random(1, #physicDefcards)
				physicDefcards[rand]:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_Defense)
				physicDefcards[rand]:getMatchCardCCBI():updateAnomalyShow()
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_TheEnd then
		local paraggiData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_UltimateParaggi);
		if paraggiData and #paraggiData ~= 0 then
			local maxNum = ((#paraggiData < 3) and #paraggiData) or 3
			local num = data.effmainparam + maxNum - 1;
			for i=data.effmainparam,num do
				local skillData = {
					effect = E_Effect.EE_Initiative,
					effmainparam = i,
					effoffparam = 0
				}
				onEffect(card,skillData);
			end
			return
		end
	elseif data.effect == E_Effect.EE_AtomicCore then --原子核心效果
		Anomalyid = E_Anomaly.EA_AtomicCore
		local atomiCoreAdd = card:getMatchCardData():getAtomiCoreAdd()
		atomiCoreAdd = atomiCoreAdd <= data.effmainparam and atomiCoreAdd or data.effmainparam --属性加值 最高不能超过50%
		local anomalyData = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_AtomicCore)
		if anomalyData and #anomalyData > 0 then
			anomalyData[#anomalyData].value = atomiCoreAdd
		else
			card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_AtomicCore, data.effoffparam, atomiCoreAdd, false)
			card.m_pMatchCardCCBI:addBuff(Anomalyid)
			card:showWenZi(data.effect, atomiCoreAdd)
			card.m_pMatchCardCCBI:updateAnomalyShow()
		end
		--end
	elseif data.effect == E_Effect.EE_Collapse then --崩坏效果
		local furyAddValue = card:getMatchCardData():getEnergyAdd()
		if furyAddValue >= data.conditionparam then  --能量累计增加值大于10 才触发
			Anomalyid = E_Anomaly.EA_Collapse
			local targetTeamCards = {}
			local team = card:getMatchCardData():getTeam()
			local targetTeam = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(team)
			local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(targetTeam)
			for k, v in ipairs(cards) do
				if not v:getMatchAnomaly():isAnomalyByType(Anomalyid) then
					table.insert(targetTeamCards, v)
				end
			end
			if #targetTeamCards > 0 then
				math.randomseed(os.time());
				local targetCard = targetTeamCards[math.random(1, #targetTeamCards)];
				local sid = card:getMatchCardData():getSID()
				targetCard:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
				local fromCID = card:getMatchCardData():getCID()   --记录buff来自于谁,用于后面查找施加buff的对象,检测是否阵亡
				local curLoopIndex = MatchCtrl:getInstance():getMatchLoop():getLoopIndex() --当前回合
				targetCard:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, fromCID, nil, sid);
				--MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), Anomalyid, targetTeam, true)
				targetCard:getMatchCardCCBI():addBuff(Anomalyid);
				targetCard:showWenZi(data.effect);
				targetCard:getMatchCardCCBI():updateAnomalyShow();
			
				MatchLog:getInstance():setCurrentCollection("afterAtk");
				MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole());
				MatchLog:getInstance():setCardMsgInfo("changePower", -card:getMatchCardData():getFury());
				
				local currHp = card:getMatchCardData():getHP()
				local minusHp = card:getMatchCardData():getHPMax() - currHp
				local hpMaxRec = card:getMatchCardData():getHPMaxRec()
				local valueHp = hpMaxRec * card:getMatchCardData():getFury() * 0.08
				valueHp = MatchFunction:match_round(valueHp)
				local realHp = valueHp > minusHp and minusHp or valueHp
				--print(string.format("-hpMaxRec:%d, minusHp:%d, valueHp:%d", hpMaxRec, minusHp, valueHp))
				
				MatchLog:getInstance():setCardMsgInfo("effectType", EFFECTTYPE.RECOVERHP);
				MatchLog:getInstance():setCardMsgInfo("changeHp", valueHp);
				card:getMatchCardData():setHP(currHp + realHp)
				card:getMatchCardCCBI():addBuff(E_BUFFID.EBI_TreatmentAdd, false, function()
						card:getMatchCardCCBI():refreshHP()
						local _ptrGroupCard = {m_pCard = card, m_pAtkCard = card} --记录伤害
						MatchStepMidAnimHit:record(_ptrGroupCard, realHp)
						local _posx, _posy = MatchFunction:getMatchCardPosition(card)--显示能量文字
						MatchEffect:recover_small(ccp(_posx, _posy), valueHp)
					end)
				
				card:getMatchCardData():setFury(0)
				card:getMatchCardCCBI():refreshFury()
				card:getMatchCardData():setEnergyAdd(0)
			end
		end
		
		return
	elseif data.effect == E_Effect.EE_D4Energy then --D4能量
		Anomalyid = E_Anomaly.EA_D4Energy
		card.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_D4Energy)
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_D4Energy, data.effoffparam, data.effmainparam);
	elseif data.effect == E_Effect.EE_DieRuined then  --死之破败
		Anomalyid = E_Anomaly.EA_DieRuined
		
		local targetTeamCards = {}
		local targetTeam = card:getMatchCardData():getTeam()
		if targetTeam == E_MATCH.TEAM_MY then
			targetTeam = E_MATCH.TEAM_OPPO
		else
			targetTeam = E_MATCH.TEAM_MY
		end
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getTeam(targetTeam)
		
		local sid = card:getMatchCardData():getSID()
		local fromCID = card:getMatchCardData():getCID()   --记录buff来自于谁,用于后面查找施加buff的对象,检测是否阵亡
		local curLoopIndex = MatchCtrl:getInstance():getMatchLoop():getLoopIndex() --当前回合
		for k, v in ipairs(cards) do
			if v:getMatchCardData():getIsVaild() == true then
				--type, count, value, bAttacker, mark, condition, passive_condition, cid, condition_param, sid, loop
				v:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
				v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, fromCID, nil, sid, curLoopIndex);
				
				local pskillData = v:getMatchCardSkill():parsePassiveSkillById(data.effmainparam)
				for _, skilldata in pairs(pskillData) do
					if skilldata.effect == E_Effect.EE_TreatmentAdd then
						v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_TreatmentAdd, skilldata.effoffparam, skilldata.effmainparam, false, nil, nil, nil, fromCID, data.effmainparam, sid, curLoopIndex)
					end
				end
				v.m_pMatchCardCCBI:addBuff(Anomalyid);
				v:showWenZi(data.effect, data.effmainparam);
				v.m_pMatchCardCCBI:updateAnomalyShow();
			end
		end
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_DieRuined, targetTeam)
		
	elseif data.effect == E_Effect.EE_Primarylight then  --原生之光
		Anomalyid = E_Anomaly.EA_Primarylight
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Primarylight, data.effoffparam, data.effmainparam);
	elseif data.effect == E_Effect.EE_MonsterCartri then --怪兽弹夹
		local anomalyData = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_MonsterCartri);
		if not anomalyData or #anomalyData < 3 then
			card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_MonsterCartri, data.effoffparam, data.effmainparam, false);
			Anomalyid = E_Anomaly.EA_MonsterCartri;
		end
		if anomalyData and #anomalyData >= 3 then
			data.effect = E_Effect.EE_Initiative;
			data.effmainparam = data.conditionparam; -- 条件参数用作触发技id
			onEffect(card,data);
			return
		end
	elseif data.effect == E_Effect.EE_Darkspell then --暗之咒术
		local _targetTeam = card:getMatchCardData():getTeam()
		_targetTeam = (_targetTeam == E_MATCH.TEAM_MY) and E_MATCH.TEAM_OPPO or E_MATCH.TEAM_MY
		local _teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getTeam(_targetTeam)		
		local _targetCards = MatchFormation:maxHP(_teamCards)
		if not next(_targetCards) then
			return
		end
		Anomalyid = E_Anomaly.EA_Darkspell
		for k, v in pairs(_targetCards) do
			v:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
			v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
		end
	elseif data.effect == E_Effect.EE_DevourCurse then --吞噬诅咒
		local index = card:getMatchCardData():getIndex()
		local teamType = card:getMatchCardData():getTeam()
		local _enemyTeamCards = MatchCtrl:getInstance():getMatchCardCtrl():getHurtCards(teamType)
		local _atkTeamCards = MatchCtrl:getInstance():getMatchCardCtrl():getAttackCards(teamType)
		
		local targetCards = {}
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_DevourCurse) then
			targetCards = MatchFormation:create(index, ATKTARGET.SELF, _enemyTeamCards, _atkTeamCards)
		else
			targetCards = MatchFormation:create(index, ATKTARGET.ALL_OPPO, _enemyTeamCards, _atkTeamCards)
		end
		for k, v in pairs(targetCards) do
			local pAnomaly = v:getMatchAnomaly()
			local anomalyData = pAnomaly:getAnomalyByType(E_Anomaly.EA_DevourCurse)
			if not anomalyData then
				pAnomaly:setAnomalyByType(E_Anomaly.EA_DevourCurse, data.effoffparam, data.effmainparam, false, nil, nil, nil, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
				v:getMatchCardCCBI():addBuff(E_Anomaly.EA_DevourCurse)
				v:showWenZi(data.effect, data.effmainparam)
				v:getMatchCardCCBI():updateAnomalyShow()				
				local targetTeam = teamType == E_MATCH.TEAM_MY and E_MATCH.TEAM_OPPO or teamType
				local skilldata = v:getMatchCardSkill():initPaSkillDatasById(999) --小于1000的是程序专用技能ID,这里999用于给对方叠加
				v:getMatchCardSkill():pushBack(skilldata)
				if k == 1 then
					MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_DevourCurse, targetTeam, false, 999)
				end
			elseif #anomalyData < 3 then
				local cid = anomalyData[1].cid
				local sid = anomalyData[1].sid
				if #anomalyData == 1 and anomalyData[1].value == 0 then
					pAnomaly:cleanOnceAnomalyByType(E_Anomaly.EA_DevourCurse)
				end
				pAnomaly:setAnomalyByType(E_Anomaly.EA_DevourCurse, data.effoffparam, data.effmainparam, false, nil, nil, nil, cid, nil, sid)
			end
			
			if anomalyData and #anomalyData >= 3 then
				local cid = anomalyData[1].cid
				local sid = anomalyData[1].sid
				pAnomaly:cleanAnomalyByType(E_Anomaly.EA_DevourCurse)
				pAnomaly:setAnomalyByType(E_Anomaly.EA_DevourCurse, data.effoffparam, 0, false, nil, nil, nil, cid, nil, sid)
				pAnomaly:setAnomalyByType(E_Anomaly.EA_Shackles, 1, 0, false, nil, nil, nil, cid, nil, sid)
				v:getMatchCardCCBI():addBuff(E_Anomaly.EA_Shackles)
				v:showWenZi(E_Effect.EE_Shackles, 0)
				v:getMatchCardCCBI():updateAnomalyShow()
				if not pAnomaly:isAnomalyByType(E_Anomaly.EA_DevourCurseMaxValue) then
					pAnomaly:setAnomalyByType(E_Anomaly.EA_DevourCurseMaxValue, data.effoffparam, data.effmainparam * 3, false, nil, nil, nil, cid, nil, sid)
				end
				local targetTeam = teamType == E_MATCH.TEAM_MY and E_MATCH.TEAM_OPPO or teamType
				if k == 1 then
					MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_Shackles, targetTeam)
					MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_DevourCurseMaxValue, targetTeam)
				end
			end
		end
		return
	elseif data.effect == E_Effect.EE_Balance then --平衡		
		local phyDefense = card:getMatchCardData():getPhysDefense()
		local specialDefense = card:getMatchCardData():getSpecialDefense()
		local distanceDefense = phyDefense - specialDefense
		local defenseValue = math.modf(distanceDefense/2)
		defenseValue = math.abs(defenseValue)
		local mark = 0
		if distanceDefense > 0 then
			card:getMatchCardData():setSpecialDefense(specialDefense + defenseValue)
			mark = 1
		else
			card:getMatchCardData():setPhysDefense(phyDefense + defenseValue)
			mark = -1
		end
		card:getMatchCardData():addAttack(defenseValue)
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_Balance, data.effoffparam, defenseValue, false, mark)
		Anomalyid = E_Anomaly.EA_Balance

	elseif data.effect == E_Effect.EE_LightdarkMark then --光暗之痕
		Anomalyid = E_Anomaly.EA_LightdarkMark
		print(card:getMatchCardData():getCID())
		if goalCard and not goalCard:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			goalCard:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
			goalCard.m_pMatchCardCCBI:addBuff(Anomalyid);
			goalCard:showWenZi(data.effect, data.effmainparam);
			goalCard.m_pMatchCardCCBI:updateAnomalyShow();
		end
		return
	elseif data.effect == E_Effect.EE_TruthEnergy then --真理能量
		Anomalyid = E_Anomaly.EA_TruthEnergy
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			card.m_pMatchCardCCBI:addBuff(Anomalyid);
			card:showWenZi(data.effect, data.effmainparam);
			card.m_pMatchCardCCBI:updateAnomalyShow();
			card:getMatchCardData():setTruthEnergy(40)
		else
			local _matchStepMid = MatchCtrl:getInstance():getMatchStepMid()
			if _matchStepMid then
				local _skillDatas = _matchStepMid:getMatchStepMidData():getSkillDatas()
				local truthEnergy = card:getMatchCardData():getTruthEnergy()
				if _skillDatas.skilltype == E_MATCH.SKILL_TYPE_FULL then  --能量技
					truthEnergy = truthEnergy + 40
					if truthEnergy >= data.conditionparam then
						truthEnergy = data.conditionparam
						card:getMatchCardData():setTruthEnergy(truthEnergy)

						data.effect = E_Effect.EE_Initiative;
						data.effmainparam = 38565; --触发技id
						onEffect(card, data)
						return;
					end
				elseif _skillDatas.skilltype == E_MATCH.SKILL_TYPE_BASIC then --普通技
					truthEnergy = truthEnergy + 20
				end
				truthEnergy = truthEnergy >= data.conditionparam and data.conditionparam or truthEnergy
				card:getMatchCardData():setTruthEnergy(truthEnergy)
			end
		end
		MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
		MatchLog:getInstance():setCardMsgInfo("truthEnergy", card:getMatchCardData():getTruthEnergy())
		return
		
	elseif data.effect == E_Effect.EE_SoulImmortal then --亡魂不灭
		local atkCard = MatchCtrl:getInstance():getMatchStepMid():getMatchStepMidData():getAtkCard()
		local atkcardAnomalyData = atkCard:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_SoulImmortal)
		
		local targetTeam = card:getMatchCardData():getTeam()
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(targetTeam)
		cards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(cards)
		
		local targetCards = {}
		for k, v in pairs(cards) do
			local anomalyData = v:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_SoulImmortal)
			if anomalyData and #anomalyData > 0 and #anomalyData < data.conditionparam then --目标卡身上有buff且未满5层
				if atkcardAnomalyData and #atkcardAnomalyData > 0 and #atkcardAnomalyData < data.conditionparam then  --攻击卡身上有buff  则一次加2层
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SoulImmortal, data.effoffparam, data.effmainparam, false, data.conditionparam, nil, data.passive_condition, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SoulImmortal, data.effoffparam, data.effmainparam, false, data.conditionparam, nil, data.passive_condition, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
				else  --否则加1层
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SoulImmortal, data.effoffparam, data.effmainparam, false, data.conditionparam, nil, data.passive_condition, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
				end
				
				anomalyData = v:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_SoulImmortal)
				local count = #anomalyData - data.conditionparam
				if count > 0 then
					for i = 1, count do
						v:getMatchAnomaly():cleanOnceAnomalyByType(E_Anomaly.EA_SoulImmortal)  --超过了5层再减去多的层数
					end
				end			
				v:showWenZi(data.effect, data.effmainparam)
				return
			elseif not anomalyData then  --没有这个buff的目标添加到 array, 以备后续用
				table.insert(targetCards, v)
			end
		end
		
		if #targetCards > 0 then			
			table.sort(targetCards, function(a, b)
				if a:getMatchCardData():getHPMaxRec() == b:getMatchCardData():getHPMaxRec() then
					return a:getMatchCardData():getIndex() < b:getMatchCardData():getIndex()
				end
				return a:getMatchCardData():getHPMaxRec() > b:getMatchCardData():getHPMaxRec()
			end)
			
			local targetCard = targetCards[1]
			targetCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SoulImmortal, data.effoffparam, data.effmainparam, false, data.conditionparam, nil, data.passive_condition, card:getMatchCardData():getCID(), nil, card:getMatchCardData():getSID())
			targetCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_SoulImmortal)
			targetCard:showWenZi(data.effect, data.effmainparam)
			targetCard:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(993) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(993)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_SoulImmortal, targetCard:getMatchCardData():getTeam(), true)
			end
		end
		
		return
	elseif data.effect == E_Effect.EE_Appendage then
		local team = card:getMatchCardData():getTeam()
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getTeam(team)
		cards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(cards)
		
		local uidList = {325, 411, 410, 66, 169, 65, 64}
		local targetCards = {}
		for i = 1, #uidList do
			for _, v in pairs(cards) do
				local cardUID = get_st_bcardinfo_value(v:getMatchCardData():getCID(), "uniqueid")
				if cardUID == uidList[i] then
					table.insert(targetCards, v)
				end
			end
			
			if #targetCards > 0 then
				break
			end
		end
		
		if #targetCards > 0 then
			table.sort(targetCards, function(a, b)
				return a:getMatchCardData():getAttack() > b:getMatchCardData():getAttack()
			end)
			
			local target = targetCards[1]
			if not target:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Appendage) then
				local sid = card:getMatchCardData():getSID()
				local cid = card:getMatchCardData():getCID()
				local value = card:getMatchCardData():getHPMaxRec()
				local hpMaxRec = target:getMatchCardData():getHPMaxRec()
				value = value > hpMaxRec and hpMaxRec or value
				target:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Appendage, data.effoffparam, data.effmainparam, false, value, nil, data.passive_condition, cid, nil, sid)
				target:getMatchCardCCBI():addBuff(E_Anomaly.EA_Appendage)
				target:showWenZi(data.effect, data.effmainparam)
				target:getMatchCardCCBI():updateAnomalyShow()
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_Appendage, target:getMatchCardData():getTeam())
			end
			
			if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_SoulForm) then
				local cardUID = get_st_bcardinfo_value(card:getMatchCardData():getCID(), "uniqueid")
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SoulForm, data.effoffparam, data.effmainparam, false, cardUID)
				card:getMatchCardCCBI():addBuff(E_Anomaly.EA_SoulForm)
				card:getMatchCardCCBI():getMatchCardHeadImage():changeHeadImage(1009)
				
				card:showWenZi(E_Effect.EE_SoulForm)
				card:getMatchCardCCBI():updateAnomalyShow()
			end
		end
		return
	elseif data.effect == E_Effect.EE_NalecPower then  --纳拉克能量
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		local baseAtk = card:getMatchCardData():getAttack()
		local value = math.modf(baseAtk / 250000)
		value = math.min(value, 10)
		value = data.effmainparam + value
		goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NalecPower, data.effoffparam, value, false, nil, nil, nil, cid, nil, sid)
		Anomalyid = E_Anomaly.EA_NalecPower
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_NalecPower, goalCard:getMatchCardData():getTeam())
	elseif data.effect == E_Effect.EE_AbsoluteForgive then --绝对宽恕
		local team = card:getMatchCardData():getTeam()
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getTeam(team)
		cards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(cards)
		for i = 1, #cards do
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbsoluteForgive, data.effoffparam, data.effmainparam, false)
		end
		Anomalyid = E_Anomaly.EA_AbsoluteForgive
		
	elseif data.effect == E_Effect.EE_AbsoluteSanction then --绝对制衡
		local team = card:getMatchCardData():getTeam()
		local oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(team)
		oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoTeams)
		
		if #oppoTeams == 1 then
			local target = oppoTeams[1]
			target:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_AbsoluteSanction)
			target:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbsoluteSanction, data.effoffparam, data.effmainparam, false)
			target:getMatchCardCCBI():addBuff(E_Anomaly.EA_AbsoluteSanction)
			target:showWenZi(E_Effect.EE_AbsoluteSanction)
			target:getMatchCardCCBI():updateAnomalyShow()
		elseif #oppoTeams > 1 then
			local targetCards = {}
			for _, v in pairs(oppoTeams) do
				if not v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_AbsoluteSanction) then
					table.insert(targetCards, v)
				end
			end
			if #targetCards > 0 then
				table.sort(targetCards, function(a, b)
						return a:getMatchCardDataAdd():getAttack() > b:getMatchCardDataAdd():getAttack()
					end)
				local target = targetCards[1]
				target:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_AbsoluteSanction)
				target:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbsoluteSanction, data.effoffparam, data.effmainparam, false)
				target:getMatchCardCCBI():addBuff(E_Anomaly.EA_AbsoluteSanction)
				target:showWenZi(E_Effect.EE_AbsoluteSanction)
				target:getMatchCardCCBI():updateAnomalyShow()
			end
		end
		
		return
	elseif data.effect == E_Effect.EE_AbsoluteHeart then --绝对之心
		if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_AbsoluteHeart) then
			--开始战斗时，添加绝对之心buff
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbsoluteHeart, data.effoffparam, data.effmainparam, false, data.conditionparam)
			card:getMatchCardCCBI():addBuff(E_Anomaly.EA_AbsoluteHeart)
			card:showWenZi(E_Effect.EE_AbsoluteHeart)
			card:getMatchCardCCBI():updateAnomalyShow()
			if card:getMatchCardSkill():addPSkillID(990) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(990)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
			Anomalyid = E_Anomaly.EA_AbsoluteHeart
		elseif not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_AbuSoleutParticle) then
			local absoluteHeartData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_AbsoluteHeart)
			if data.passive_condition == E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE and absoluteHeartData[1].mark == 0 then --受到致命伤害时，此时 诈死：把血量设置为10
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, data.effmainparam, false)
				absoluteHeartData[1].mark = 1 --表示受到了致命伤害
			elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_TARGET_HP_CHECK and absoluteHeartData[1].mark == 1 then --诈死之后，血量检查时再添加阿布索留特粒子buff
				local collectionKey = MatchLog:getInstance():getCurrentCollection()
				MatchLog:getInstance():setCurrentCollection("afterAtk")
				MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
				
				card:getMatchAnomaly():cleanAllDebuffAndAnomaly()
				local value = data.effmainparam * card:getMatchCardData():getHPMaxRec() / 100
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbuSoleutParticle, data.effoffparam, value, false)
				card:getMatchCardCCBI():addBuff(E_Anomaly.EA_AbuSoleutParticle)
				card:showWenZi(E_Effect.EE_AbuSoleutParticle)
				card:getMatchCardCCBI():updateAnomalyShow()
				absoluteHeartData[1].mark = 2
				
				MatchLog:getInstance():setCurrentCollection(collectionKey)
			end
		end
		return
	elseif data.effect == E_Effect.EE_SuckHpEqualDivide then --吸血并均分		
		local targetCards = {}
		local team = card:getMatchCardData():getTeam()
		local teamMembers = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(team)		
		local condition1,condition2,condition3,condition4 = transformFaction(data.conditionparam)
		for _, v in pairs(teamMembers) do
			local cid = v:getMatchCardData():getCID()
			local factionId = get_st_bcardinfo_value(cid, "faction")
			if G_if_var_in(factionId, condition1, condition2, condition3, condition4) then
				table.insert(targetCards, v)
			end
		end
		
		if #targetCards > 0 then
			local damage = card:getMatchCardData():getEffect1MainDamage()
			damage = math.abs(damage)
			local recoverHp = math.floor(damage * data.effmainparam / 100 / #targetCards)
			for _, target in pairs(targetCards) do
				if not target:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_AbuSoleutParticle) then
					local currHp = target:getMatchCardData():getHP()
					target:getMatchCardData():setHP(currHp + recoverHp)
					
					MatchLog:getInstance():locateCardMsgByIndexSole(target:getMatchCardData():getIndexSole())
					MatchLog:getInstance():setCardMsgInfo("effectType", EFFECTTYPE.RECOVERHP)
					MatchLog:getInstance():setCardMsgInfo("changeHp", recoverHp)
					target:getMatchCardCCBI():addBuff(E_BUFFID.EBI_TreatmentAdd, false, function()
							target:getMatchCardCCBI():refreshHP()
							local _posx, _posy = MatchFunction:getMatchCardPosition(target)--显示文字
							MatchEffect:recover_small(ccp(_posx, _posy), recoverHp)
						end)
				end
			end
		end
		return
	elseif data.effect == E_Effect.EE_AbsoluteAbyss then --绝对深渊
		local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_AbsoluteAbyss)
		if anomalyData and #anomalyData > 0 then
			if data.passive_condition == E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE then
				if anomalyData[1].mark == 0 then --第一次致命伤害时
					data.effect = E_Effect.EE_Initiative
					onEffect(card, data)
					anomalyData[1].mark = 1
				end
			elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_TARGET_HP_CHECK then --目标血量检测
				local hp = card:getMatchCardData():getHP()
				if hp > 0 then
					local maxHp = card:getMatchCardData():getHPMax()
					local hpPercent = math.max(math.floor(hp / maxHp * 100), 1)
					if hpPercent > 0 and hpPercent <= 50 then
						if not anomalyData[1].condition_param or
							#anomalyData[1].condition_param < 3 then
							anomalyData[1].condition_param = {20, 30, 40}
						end
					elseif hpPercent > 50 and hpPercent <= 75 then
						if not anomalyData[1].condition_param or
							#anomalyData[1].condition_param < 2 then
							anomalyData[1].condition_param = {20, 30}
						end
					elseif hpPercent < 100 then
						if not anomalyData[1].condition_param then
							anomalyData[1].condition_param = {20}
						end
					end
				end
			end
		else
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AbsoluteAbyss, data.effoffparam, data.effmainparam, false, 0)
			card:getMatchCardCCBI():addBuff(E_Anomaly.EA_AbsoluteAbyss)
			card:showWenZi(E_Effect.EE_AbsoluteAbyss)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(991) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(991)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
			
		end
		
		return
	elseif data.effect == E_Effect.EE_GoldenManRunSkillExt then --小金人额外执行一个触发技,触发技是小金人自带的
		--注意：这里goalCard是攻击卡，card是小金人
		local teamType = goalCard:getMatchCardData():getTeam()
		if teamType == card:getMatchCardData():getTeam() then
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			local targetCard = MatchFormation:maxAtkAdd(teamCards)[1]
			if targetCard and goalCard:getMatchCardData():getCID() == targetCard:getMatchCardData():getCID() then
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_RunTriggerSkillExtension, data.effoffparam, data.effmainparam, false)
			end
		end

		return
	elseif data.effect == E_Effect.EE_TruthNeverDie then --不灭真理
		Anomalyid = E_Anomaly.EA_TruthNeverDie
		card.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_TruthNeverDie)
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TruthNeverDie, data.effoffparam, data.effmainparam, false);
	elseif data.effect == E_Effect.EE_SpallingForce then --崩裂之力
		Anomalyid = E_Anomaly.EA_SpallingForce
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_SpallingForce, data.effoffparam, data.effmainparam, false);
	elseif data.effect == E_Effect.EE_PollutionSeal then --污染之章
		Anomalyid = E_Anomaly.EA_PollutionSeal
		local indexSole = card:getMatchCardData():getIndexSole()
		local sid = card:getMatchCardData():getSID()
		local cid = card:getMatchCardData():getCID()
		local team = card:getMatchCardData():getTeam()
		local oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(team)
		oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoTeams)
		if #oppoTeams > 0 then
			if #oppoTeams == 1 then
				local averageNum = math.floor(data.conditionparam / 2)
				for i = 1, averageNum do
					oppoTeams[1]:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PollutionSeal, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid)
					card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PollutionSeal, data.effoffparam, 5, false, indexSole, nil, nil, cid)
				end
				
				oppoTeams[1]:getMatchCardCCBI():addBuff(E_Anomaly.EA_PollutionSeal)
				oppoTeams[1]:showWenZi(data.effect)
				oppoTeams[1]:getMatchCardCCBI():updateAnomalyShow()
				
				MatchRunAction:delayTime(function()
						card:getMatchCardCCBI():addBuff(E_Anomaly.EA_PollutionSeal)
						card:showWenZi(data.effect)
						card:getMatchCardCCBI():updateAnomalyShow()
				end, 0.5)
			else
				local averageNum = math.floor(data.conditionparam / #oppoTeams)  --全体平均获得 averageNum 枚印章
				local extendNum = data.conditionparam % #oppoTeams  --不能整除的，则前生命值最高者获得额外印章
				for _, v in pairs(oppoTeams) do
					for i = 1, averageNum do
						v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PollutionSeal, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid)
					end
					v:getMatchCardCCBI():addBuff(E_Anomaly.EA_PollutionSeal)
					v:showWenZi(data.effect)
					v:getMatchCardCCBI():updateAnomalyShow()
				end
				if extendNum > 0 then
					table.sort(oppoTeams, function(a, b)
						return a:getMatchCardData():getHP() > b:getMatchCardData():getHP()
					end)
					for i = 1, extendNum do
						oppoTeams[1]:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PollutionSeal, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid)
					end
				end
			end
		end
			
		return
	elseif data.effect == E_Effect.EE_G_Crystal then --G水晶
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_G_Crystal) then
			local team = card:getMatchCardData():getTeam()
			local validCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(team)
			local MAXFLOOR = data.conditionparam
			local getFinalFloor = function(buffType, apareFloor)
				apareFloor = apareFloor > 0 and apareFloor or 0
				local anomalyData = card:getMatchAnomaly():getAnomalyByType(buffType)
				local ownFloor = anomalyData and #anomalyData or 0  --已经拥有的层数
				local needAddFloor = MAXFLOOR - ownFloor  --需要的层数
				needAddFloor = needAddFloor > 0 and needAddFloor or 0
				local overflowFloor = apareFloor - needAddFloor  --溢出的层数
				local finalFloor = overflowFloor > 0 and needAddFloor or apareFloor  --最终添加的层数
				
				return finalFloor, overflowFloor
			end
			
			local attackFloor, attackOverFloor = getFinalFloor(E_Anomaly.EA_G_Crystal_Attack, #validCards)
			local attackFlag = attackFloor > 0
			for i = 1, attackFloor do
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_G_Crystal_Attack, data.effoffparam, data.effmainparam, false, MAXFLOOR)
			end
			
			local apareFloor = E_MATCH.CONST_MEMBER_MAX - #validCards  --当前可以添加的层数
			local defendFloor, defendOverFloor = getFinalFloor(E_Anomaly.EA_G_Crystal_Defend, apareFloor)
			local defendFlag = defendFloor > 0
			for i = 1, defendFloor do
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_G_Crystal_Defend, data.effoffparam, data.effmainparam, false, MAXFLOOR)
			end
			
			if attackOverFloor > 0 then
				defendFloor = getFinalFloor(E_Anomaly.EA_G_Crystal_Defend, attackOverFloor)
				defendFlag = defendFlag or defendFloor > 0
				for i = 1, defendFloor do
					card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_G_Crystal_Defend, data.effoffparam, data.effmainparam, false, MAXFLOOR)
				end
			elseif defendOverFloor > 0 then
				attackFloor = getFinalFloor(E_Anomaly.EA_G_Crystal_Attack, defendOverFloor)
				attackFlag = attackFlag or attackFloor > 0
				for i = 1, attackFloor do
					card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_G_Crystal_Attack, data.effoffparam, data.effmainparam, false, MAXFLOOR)
				end
			end
			
			local anomalyCrystalAttack = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_G_Crystal_Attack)
			if anomalyCrystalAttack and #anomalyCrystalAttack >= MAXFLOOR then
				local gCrystalData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_G_Crystal)
				card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_TriggerSkill, 1, gCrystalData[1].mark, false)
			end
			
			local anomalyCrystalDefend = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_G_Crystal_Defend)
			if anomalyCrystalDefend and #anomalyCrystalDefend >= MAXFLOOR then
				if card:getMatchCardSkill():addPSkillID(989) then
					local skilldata = card:getMatchCardSkill():initPaSkillDatasById(989)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					card:getMatchCardSkill():pushBack(skilldata)
				end
			end
			
			local showAnomalyBuffText = function(buffType, showBuffEffectFunc)
				local _posx, _posy = MatchFunction:getMatchCardPosition(card)
				card.m_pMatchCardCCBI:addBuff(buffType)
				showBuffEffectFunc(self, ccp(_posx, _posy))
				card.m_pMatchCardCCBI:updateAnomalyShow()
			end
			
			if attackFlag and not defendFlag then
				showAnomalyBuffText(E_Anomaly.EA_G_Crystal_Attack, MatchEffect.gCrystalAttack)
			elseif defendFlag and not attackFlag then
				showAnomalyBuffText(E_Anomaly.EA_G_Crystal_Defend, MatchEffect.gCrystalDefend)
			elseif attackFlag and defendFlag then
				showAnomalyBuffText(E_Anomaly.EA_G_Crystal_Attack, MatchEffect.gCrystalAttack)
				MatchRunAction:delayTime(function()
					showAnomalyBuffText(E_Anomaly.EA_G_Crystal_Defend, MatchEffect.gCrystalDefend)
				end, 0.1)
			end
		elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_BATTLE_START then
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_G_Crystal, data.effoffparam, data.effmainparam, false, data.conditionparam)
			card.m_pMatchCardCCBI:addBuff(E_Anomaly.EA_G_Crystal)
			card:showWenZi(data.effect, data.effmainparam)
			card.m_pMatchCardCCBI:updateAnomalyShow()
		end
		
		return
	elseif data.effect == E_Effect.EE_FireAndPoisonImmune then --燃烧和中毒免疫合体
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_FireAndPoisonImmune, data.effoffparam, data.effmainparam, false);
		Anomalyid = E_Anomaly.EA_FireAndPoisonImmune;
	
	elseif data.effect == E_Effect.EE_NewPowerOfRebirth then --新生代之力
		goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NewPowerOfRebirth, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, nil, card:getMatchCardData():getSID())
		if card:getMatchCardData():getCID() == goalCard:getMatchCardData():getCID() or 
			MatchFormation:checkIsNewRebirthRole(goalCard:getMatchCardForm():getUniqueid()) then
			
			local attackValue = card:getMatchCardData():getAttack()
			local attackAddValue = math.floor(attackValue / 250000)
			attackAddValue = attackAddValue < 10 and attackAddValue or 10
			goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NewPowerOfRebirth, data.effoffparam, attackAddValue, false, nil, nil, nil, nil, nil, card:getMatchCardData():getSID()) 
		end
		goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_NewPowerOfRebirth)
		goalCard:showWenZi(data.effect, data.effmainparam)
		goalCard:getMatchCardCCBI():updateAnomalyShow()
		
		if card:getMatchCardData():getCID() == goalCard:getMatchCardData():getCID() then
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_NewPowerOfRebirth, card:getMatchCardData():getTeam())
		end
				
		return
	elseif data.effect == E_Effect.EE_PowerOfInherit then --传承之力
		card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PowerOfInherit, data.effoffparam, data.effmainparam, false)
		Anomalyid = E_Anomaly.EA_PowerOfInherit	
	elseif data.effect == E_Effect.EE_AutorHorn then --奥特之角
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AutorHorn, data.effoffparam, data.effmainparam, false, 4, nil, nil, cid, nil, sid)
		Anomalyid = E_Anomaly.EE_AutorHorn
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_AutorHorn, card:getMatchCardData():getTeam())
		
	elseif data.effect == E_Effect.EE_HoldOn then  --招架
		local teamType = card:getMatchCardData():getTeam();
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_HoldOn, teamType)	
		for i,v in ipairs(teamCards) do
			local parry = math.floor(v:getMatchCardData():getParry()) * data.conditionparam
			if v:getMatchCardData():getCID() == card:getMatchCardData():getCID() then
				parry = parry < 60 and parry or 60
				parry = data.effmainparam + parry
			else
				parry = parry < 50 and parry or 50
			end
			v.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_HoldOn, data.effoffparam, parry, false, nil, nil, nil, nil, nil, card:getMatchCardData():getSID())
			v:getMatchCardCCBI():addBuff(E_Anomaly.EA_HoldOn)
			v:showWenZi(data.effect)
			v:getMatchCardCCBI():updateAnomalyShow()
		end
		
		return
	elseif data.effect == E_Effect.EE_NewLightOfRebirth then --新生代之光
		if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_NewLightOfRebirth) then
			local attackValue = card:getMatchCardData():getAttack()
			local indexSole = card:getMatchCardData():getIndexSole()
			local maxDamage = attackValue * data.conditionparam / 100
			--card:getMatchCardData():setTriggerSkillExtDamageMax(maxDamage)
			for i = 1, 6 do --开场时添加6层
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NewLightOfRebirth, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, maxDamage)
			end
			card:getMatchCardCCBI():addBuff(E_Anomaly.EA_NewLightOfRebirth)
			card:showWenZi(data.effect)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(988) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(988)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
			
			if card:getMatchCardSkill():addPSkillID(987) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(987)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		elseif card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_FeignDeath) then --受到致命伤害时回血，并且清除buff层数
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NewLightOfRebirth)
			if #anomalyData > 1 then
				local count = #anomalyData <= data.conditionparam and #anomalyData - 1 or data.conditionparam
				local value = card:getMatchCardData():getHPMax() * data.effmainparam / 100 * count
				value = math.floor(value)
				for i = 1, count do
					card:getMatchAnomaly():cleanOnceAnomalyByType(E_Anomaly.EA_NewLightOfRebirth)
				end
				card:setHP(value)
				card:showWenZi(data.effect)
				card:getMatchAnomaly():cleanAllDebuffAndAnomaly()
				
				local _ptrGroupCard = {m_pCard = card}--记录伤害
				MatchStepMidAnimHit:record(_ptrGroupCard, value)
				local _posx, _posy = MatchFunction:getMatchCardPosition(card)
				MatchEffect:recover_small(ccp(_posx, _posy), value)
				MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
				MatchLog:getInstance():setCardMsgInfo("isLethal", E_Anomaly.EA_NewLightOfRebirth)
				MatchLog:getInstance():addNewBuffToCardMsg(E_Anomaly.EA_NewLightOfRebirth, count, -103, card:getMatchCardData():getIndexSole())
				
				local feignDeathData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_FeignDeath)
				for i = 1, #feignDeathData do
					feignDeathData[i].value = feignDeathData[i].value + value
				end
			else
				card:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_FeignDeath)
			end
		elseif goalCard and goalCard:getMatchCardData():getTeam() ~= card:getMatchCardData():getTeam() then
			--本次敌方攻击即将结束时，额外触发我方新生代角色的主动技,  注意：这里goalCard是攻击卡，card是新生代角色
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NewLightOfRebirth)
			if #anomalyData > 1 then
				for i = 1, #anomalyData do --开场时添加6层
					anomalyData[i].mark = data.effmainparam  --记录他触发的主动技能是多少,用于校验
				end
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_RunTriggerSkillExtension, data.effoffparam, data.effmainparam, false)
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_NewRallyOfRebirth then --新生代集结
		local teamType = card:getMatchCardData():getTeam();
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		for _, v in pairs(teamCards) do
			local uid = v:getMatchCardForm():getUniqueid()
			local indexSole = v:getMatchCardData():getIndexSole()
			if cid ~= v:getMatchCardData():getCID() and MatchFormation:checkIsNewRebirthRole(uid) then
				local giddyRateAnti = v:getMatchCardData():getGiddyRateAnti() * 100 --眩晕抗性概率
				local value = (giddyRateAnti - data.effmainparam) * data.conditionparam
				value = value > 0 and value or 0
				v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NewRallyOfRebirth, data.effoffparam, value, false, indexSole, nil, nil, cid, nil, sid)
				v:getMatchCardCCBI():addBuff(E_Anomaly.EA_NewRallyOfRebirth)
				v:showWenZi(data.effect)
				v:getMatchCardCCBI():updateAnomalyShow()
			end
		end
		
		local indexSole = card:getMatchCardData():getIndexSole()
		card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NewRallyOfRebirth, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, nil, sid)
		card:getMatchCardCCBI():addBuff(E_Anomaly.EA_NewRallyOfRebirth)
		card:showWenZi(data.effect)
		card:getMatchCardCCBI():updateAnomalyShow()
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_NewRallyOfRebirth, teamType)

		return
	elseif data.effect == E_Effect.EE_TripleBarrier then --三重屏障
		local loopIndex = MatchCtrl:getInstance():getMatchLoop():getLoopIndex()
		if loopIndex % 2 == 1 then --奇数回合
			local teamType = card:getMatchCardData():getTeam();
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			local condition1,condition2,condition3,condition4 = transformFaction(data.conditionparam);
			for _, v in pairs(teamCards) do
				v:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_TripleSpark)
				MatchLog:getInstance():locateCardMsgByIndexSole(v:getMatchCardData():getIndexSole())
				MatchLog:getInstance():addNewBuffToCardMsg(E_Anomaly.EA_TripleSpark, 0, -99, 0)
				local faction = v:getMatchCardForm():getMatchCardFormInfo():getFaction()
				if G_if_var_in(faction, condition1, condition2, condition3, condition4) then
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_TripleBarrier, data.effoffparam, data.effmainparam, false)
					v:getMatchCardCCBI():addBuff(E_Anomaly.EA_TripleBarrier)
					v:showWenZi(data.effect)
					v:getMatchCardCCBI():updateAnomalyShow()
				end
			end
		end
		return
		
	elseif data.effect == E_Effect.EE_TripleSpark then --三重火花
		local loopIndex = MatchCtrl:getInstance():getMatchLoop():getLoopIndex()
		if loopIndex % 2 == 0 then --偶数回合
			local indexSole = card:getMatchCardData():getIndexSole()
			local cid = card:getMatchCardData():getCID()
			local teamType = card:getMatchCardData():getTeam();
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			local condition1,condition2,condition3,condition4 = transformFaction(data.conditionparam);
			for _, v in pairs(teamCards) do
				v:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_TripleBarrier)
				MatchLog:getInstance():locateCardMsgByIndexSole(v:getMatchCardData():getIndexSole())
				MatchLog:getInstance():addNewBuffToCardMsg(E_Anomaly.EA_TripleBarrier, 0, -99, 0)
				local faction = v:getMatchCardForm():getMatchCardFormInfo():getFaction()
				if G_if_var_in(faction, condition1, condition2, condition3, condition4) then
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_TripleSpark, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid)
					v:getMatchCardCCBI():addBuff(E_Anomaly.EA_TripleSpark)
					v:showWenZi(data.effect)
					v:getMatchCardCCBI():updateAnomalyShow()
				end
			end
		end
		return
	elseif data.effect == E_Effect.EE_HammerKing then --王者之锤
		if card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_HammerKing) >= 30 then
			return
		end
		card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_HammerKing, data.effoffparam, data.effmainparam, false)
		Anomalyid = E_Anomaly.EA_HammerKing
	elseif data.effect == E_Effect.EE_Gift then  --恩赐
		local teamType = card:getMatchCardData():getTeam()
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		local targetCard = MatchFormation:maxHP(teamCards)[1]
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		local indexSole = card:getMatchCardData():getIndexSole()
		targetCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Gift, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, nil, sid)
		targetCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_Gift)
		targetCard:showWenZi(data.effect)
		targetCard:getMatchCardCCBI():updateAnomalyShow()
		if card:getMatchCardSkill():addPSkillID(986) then
			local skilldata = card:getMatchCardSkill():initPaSkillDatasById(986)--小于1000的是程序专用技能ID,这里999用于给对方叠加
			card:getMatchCardSkill():pushBack(skilldata)
		end
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_Gift, teamType)
		
		return
	elseif data.effect == E_Effect.EE_Blessing then  --祝福
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Blessing) then
			if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_FeignDeath) then
				local recoverHp = card:getMatchAnomaly():getDataAddByType(E_Anomaly.EA_Blessing)
				recoverHp = math.floor(recoverHp * card:getMatchCardData():getHPMax() / 100)				
				local feignDeathData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_FeignDeath)
				feignDeathData[1].value = feignDeathData[1].value + recoverHp
				card:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_Blessing)
				card:showWenZi(data.effect, data.effmainparam)
				
				MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
				MatchLog:getInstance():setCardMsgInfo("isLethal", E_Anomaly.EA_Blessing)
			end
			return
		else
			local hp = card:getMatchCardData():getHP()
			local hpMax = card:getMatchCardData():getHPMax()
			local value = math.floor(hp * 100 / hpMax)
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Blessing, data.effoffparam, value, false)
			Anomalyid = E_Anomaly.EA_Blessing
			
			if card:getMatchCardSkill():addPSkillID(985) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(985)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
	elseif data.effect == E_Effect.EE_KingOfRoyalcrown then --王之冠冕
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		local indexSole = card:getMatchCardData():getIndexSole()
		local teamType = card:getMatchCardData():getTeam()
		goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_KingOfRoyalcrown, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, nil, sid)		
		goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_KingOfRoyalcrown)
		goalCard:showWenZi(data.effect, data.effmainparam)
		goalCard:getMatchCardCCBI():updateAnomalyShow()
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_KingOfRoyalcrown, teamType, true)
		
		return
	elseif data.effect == E_Effect.EE_Hollowing then --空翼
		local teamType = card:getMatchCardData():getTeam()
		if teamType == goalCard:getMatchCardData():getTeam() then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			local extendNum = math.floor(card:getMatchCardData():getAttack() / 250000)
			extendNum = extendNum <= 10 and extendNum or 10
			local value = data.effmainparam + extendNum
			goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Hollowing, data.effoffparam, value, false, indexSole, nil, nil, cid, nil, sid)
			Anomalyid = E_Anomaly.EA_Hollowing
			goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_Hollowing)
			goalCard:showWenZi(data.effect)
			goalCard:getMatchCardCCBI():updateAnomalyShow()
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_Hollowing, teamType, false)
		end
		return
	elseif data.effect == E_Effect.EE_GroundFissure then  --地裂
		local teamType = card:getMatchCardData():getTeam()
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		local targetCards = MatchFormation:specialCamp(teamCards, data.conditionparam) --己方所有怪兽角色
		if #targetCards > 0 then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			for k, v in ipairs(targetCards) do
				local value = math.floor(v:getMatchCardData():getHPMax() * data.effmainparam / 100)
				v:getMatchCardData():setHPMax(v:getMatchCardData():getHPMax() + value)
				v:getMatchCardData():setHP(v:getMatchCardData():getHPMax())
				v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Hollowing, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, nil, sid)
				v:getMatchCardCCBI():addBuff(E_Anomaly.EA_Hollowing)
				v:showWenZi(data.effect)
				v:getMatchCardCCBI():updateAnomalyShow()
			end
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_Hollowing, teamType, false)
		end
		return
	elseif data.effect == E_Effect.EE_WishingMark then --愿痕
		if data.passive_condition ==  E_PSKILLCONDITIONS.EPC_MAINSKILL_ATTACK then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			local teamType = card:getMatchCardData():getTeam()
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(teamCards)
			table.sort(teamCards, function(a, b)
				return a:getMatchCardDataAdd():getAttack() > b:getMatchCardDataAdd():getAttack()
			end)
			for k, v in ipairs(teamCards) do
				if k <= 2 then
					v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_WishingMark, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, 984, sid)
					v:getMatchCardCCBI():addBuff(E_Anomaly.EA_WishingMark)
					v:showWenZi(data.effect)
					v:getMatchCardCCBI():updateAnomalyShow()
					
					if v:getMatchCardSkill():addPSkillID(984) then
						local skilldata = v:getMatchCardSkill():initPaSkillDatasById(984)--小于1000的是程序专用技能ID,这里999用于给对方叠加
						v:getMatchCardSkill():pushBack(skilldata)
					end
				end
			end
			
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_WishingMark, teamCards[1]:getMatchCardData():getTeam(), false, 984)
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_WishingMark)
			if anomalyData then
				local targetCard = MatchCtrl:getInstance():getMatchCardCtrl():getCardWithIndexSole(anomalyData[1].mark)			
				if targetCard:getMatchCardData():getCID() == anomalyData[1].cid and data.conditionparam == E_Effect.EE_Initiative then
					data.effect = E_Effect.EE_Initiative
					onEffect(targetCard, data)
				end
			else
				card:getMatchCardSkill():removePSkillID(984)
			end
		end

		return
		
	elseif data.effect == E_Effect.EE_GreedSpirit then --贪欲之灵
		for i = 1, data.conditionparam do
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_GreedSpirit, data.effoffparam, data.effmainparam, false)
		end
		card:getMatchCardCCBI():addBuff(E_Anomaly.EA_GreedSpirit)
		card:showWenZi(data.effect)
		card:getMatchCardCCBI():updateAnomalyShow()
		
		if card:getMatchCardSkill():addPSkillID(983) then
			local skilldata = card:getMatchCardSkill():initPaSkillDatasById(983)--小于1000的是程序专用技能ID,这里999用于给对方叠加
			card:getMatchCardSkill():pushBack(skilldata)
		end

		return
	elseif data.effect == E_Effect.EE_NightmareWish then --噩愿
		local teamType = card:getMatchCardData():getTeam()
		if teamType == goalCard:getMatchCardData():getTeam() then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_NightmareWish, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, 982, sid)
			goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_NightmareWish)
			goalCard:showWenZi(data.effect)
			goalCard:getMatchCardCCBI():updateAnomalyShow()
			if goalCard:getMatchCardSkill():addPSkillID(982) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(982)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				goalCard:getMatchCardSkill():pushBack(skilldata)
			end
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_NightmareWish, teamType, false, 982)
		end
		return
	elseif data.effect == E_Effect.EE_BoneCrushed then --骨碎
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_NightmareWish) then
			local atkCard = goalCard[1]
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NightmareWish)
			local boneCrushData = atkCard:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_BoneCrushed)
			if not boneCrushData or #boneCrushData < 8 then  --最大8层
				atkCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_BoneCrushed, data.effoffparam, data.effmainparam, false, anomalyData[1].mark, nil, nil, anomalyData[1].cid, nil, anomalyData[1].sid)
				atkCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_BoneCrushed)
				atkCard:showWenZi(E_Effect.EE_BoneCrushed)
				atkCard:getMatchCardCCBI():updateAnomalyShow()
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(anomalyData[1].sid, E_Anomaly.EA_BoneCrushed, atkCard:getMatchCardData():getTeam(), false)
				
				boneCrushData = atkCard:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_BoneCrushed)
				if #boneCrushData >= 8 and not atkCard:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_HardPalate) then
					--8层后添加一层裂颚
					atkCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_HardPalate, data.effoffparam, data.conditionparam, false, anomalyData[1].mark, nil, nil, anomalyData[1].cid, 15, anomalyData[1].sid) --15 用作裂颚伤害的百分比计算
					atkCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_HardPalate)
					atkCard:showWenZi(E_Effect.EE_HardPalate)
					atkCard:getMatchCardCCBI():updateAnomalyShow()
					
					MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(anomalyData[1].sid, E_Anomaly.EA_HardPalate, atkCard:getMatchCardData():getTeam(), false)
				end
			end
		end
		
		return
	elseif data.effect == E_Effect.EE_BoneShield then  --骨盾
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		local indexSole = card:getMatchCardData():getIndexSole()
		local teamType = card:getMatchCardData():getTeam()
		goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_BoneShield, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, nil, sid)
		goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_BoneShield)
		goalCard:showWenZi(E_Effect.EE_BoneShield)
		goalCard:getMatchCardCCBI():updateAnomalyShow()
		
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_BoneShield, teamType, false)
		return
		
	elseif data.effect == E_Effect.EE_HopeOfRuby then --愿之红玉
		if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_HopeOfRuby) then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local hpMaxRec = card:getMatchCardData():getHPMaxRec()
			local valueMax = math.floor(hpMaxRec * data.conditionparam / 100) --设定上限值
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_HopeOfRuby, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, valueMax, sid)
			card:getMatchCardCCBI():addBuff(E_Anomaly.EA_HopeOfRuby)
			card:showWenZi(E_Effect.EE_HopeOfRuby)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(981) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(981)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		elseif card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_FeignDeath) then
			if card:getMatchCardSkill():havePSkillID(981) then
				if card:getMatchCardSkill():addPSkillID(980) then
					local skilldata = card:getMatchCardSkill():initPaSkillDatasById(980)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					card:getMatchCardSkill():pushBack(skilldata)
					card:getMatchCardSkill():removeSkillById(981)
				end
			elseif card:getMatchCardSkill():havePSkillID(980) then
				local callFunc = function()
					local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_HopeOfRuby)
					local recoverHp = anomalyData[1].mark
					anomalyData[1].mark = 0
					--card:setHP(recoverHp)
					card:getMatchCardData():setHP(recoverHp)
					card:getMatchCardCCBI():refreshHP(function()
						card:showWenZi(data.effect)
					end)
					local _ptrGroupCard = {m_pCard = card}--记录伤害
					MatchStepMidAnimHit:record(_ptrGroupCard, recoverHp)
					local _posx, _posy = MatchFunction:getMatchCardPosition(card)
					MatchEffect:recover_small(ccp(_posx, _posy), recoverHp)
					
					local currCollection = MatchLog:getInstance():getCurrentCollection()
					MatchLog:getInstance():setCurrentCollection("afterAtk")
					MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
					MatchLog:getInstance():setCardMsgInfo("changeHp", recoverHp)
					MatchLog:getInstance():setCardMsgInfo("effectType", EFFECTTYPE.RECOVERHP)
					
					MatchLog:getInstance():setCurrentCollection(currCollection)
					MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
					MatchLog:getInstance():setCardMsgInfo("isLethal", E_Anomaly.EA_HopeOfRuby)
					anomalyData[1].mark = 0
					card:getMatchCardSkill():removeSkillById(980)
				end
				MatchRunAction:delayTime(callFunc, 0.1)
			end
		end
		return
		
	elseif data.effect == E_Effect.EE_ElegyOfBeasts then --融合兽之哀歌 
		local teamType = card:getMatchCardData():getTeam()
		if teamType == goalCard:getMatchCardData():getTeam() then
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			local extendNum = math.floor(card:getMatchCardData():getAttack() / 250000)
			extendNum = extendNum <= 10 and extendNum or 10
			local value = data.effmainparam + extendNum
			goalCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_ElegyOfBeasts, data.effoffparam, value, false, indexSole, nil, nil, cid, nil, sid)
			goalCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_ElegyOfBeasts)
			goalCard:showWenZi(data.effect)
			goalCard:getMatchCardCCBI():updateAnomalyShow()
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_ElegyOfBeasts, teamType, true)
		end
		return
	elseif data.effect == E_Effect.EE_AllDamageAddMainValue then --给攻击卡队友提升全伤增幅buff值
		if type(goalCard) == "table" and #goalCard > 0 then
			local team = card:getMatchCardData():getTeam()
			local cond1,cond2,cond3,cond4 = transformFaction(data.conditionparam)
			for k, v in pairs(goalCard) do
				if team == v:getMatchCardData():getTeam() and v:getMatchCardData():getIsVaild() then
					local cid = v:getMatchCardData():getCID()
					local fid = get_st_bcardinfo_value(cid, "faction")
					if G_if_var_in(fid, cond1, cond2, cond3, cond4) then --同队友满足阵营条件的,全伤增幅加值
						v:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AllDamageAdd, data.effoffparam, data.effmainparam, false)
						v:getMatchCardCCBI():addBuff(E_Anomaly.EA_AllDamageAdd)
						v:showWenZi(E_Effect.EE_AllDamageAdd, data.effmainparam)
						v:getMatchCardCCBI():updateAnomalyShow()
					end
				end
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_ShineStar then --耀星
		local team = card:getMatchCardData():getTeam()
		local oppoTeam = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(team)
		local oppoTeamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(oppoTeam)
		local target = MatchFormation:maxHP(oppoTeamCards)
		
		local indexSole = card:getMatchCardData():getIndexSole()
		local cid = card:getMatchCardData():getCID()
		local sid = card:getMatchCardData():getSID()
		
		if target and #target > 0 then
			Anomalyid = E_Anomaly.EA_ShineStar
			for k, v in pairs(oppoTeamCards) do
				if v:getMatchAnomaly():isAnomalyByType(Anomalyid) then
					v:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
				end
			end
			target[1]:getMatchCardSkill():setFullskillFuryAdd(0)
			local pskillData = target[1]:getMatchCardSkill():parsePassiveSkillById(978)
			if target[1]:getMatchCardData():getAttribute() == E_MATCH.ATTRIBUTE_MONSTER then
				target[1]:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, pskillData[2].effmainparam, false, 10002, nil, nil, cid, pskillData[2].conditionparam, sid)
			else
				target[1]:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, pskillData[1].effmainparam, false, 10001, nil, nil, cid, pskillData[1].conditionparam, sid)
				target[1]:getMatchCardSkill():setFullskillFuryAdd(data.effmainparam)
			end
			target[1]:getMatchCardCCBI():addBuff(Anomalyid)
			target[1]:showWenZi(data.effect, data.effmainparam)
			target[1]:getMatchCardCCBI():updateAnomalyShow()
		end
		
		return
		
	elseif data.effect == E_Effect.EE_DimensionLight then --次元之光
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_DimensionLight) then
			--回合开始时，有该buff的角色能量加2点
			card:setFury(data.effmainparam)
			local _posx, _posy = MatchFunction:getMatchCardPosition(card)
			MatchEffect:fury(ccp(_posx, _posy), data.effmainparam)
			
			local currCollection = MatchLog:getInstance():getCurrentCollection()
			MatchLog:getInstance():setCurrentCollection("beforeAtk")
			MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
			MatchLog:getInstance():setCardMsgInfo("changePower", data.effmainparam)
			MatchLog:getInstance():setCardMsgInfo("showPowerText", data.effmainparam)
			MatchLog:getInstance():setCurrentCollection(currCollection)

		elseif card:getMatchCardSkill():havePSkillID(977) then
			card:getMatchCardSkill():removeSkillById(977)
		end
		
	elseif data.effect == E_Effect.EE_ShiningPower then  --闪亮动力
		Anomalyid = E_Anomaly.EA_ShiningPower
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_ShiningPower, data.effoffparam, data.effmainparam, false);
	elseif data.effect == E_Effect.EE_StrengthPower then  --强壮动力
		Anomalyid = E_Anomaly.EA_StrengthPower
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_StrengthPower, data.effoffparam, data.effmainparam, false);
	elseif data.effect == E_Effect.EE_MiraclesPower then  --奇迹动力
		Anomalyid = E_Anomaly.EA_MiraclesPower
		card.m_pMatchAnomaly:setAnomalyByType(E_Anomaly.EA_MiraclesPower, data.effoffparam, data.effmainparam, false);	
	elseif data.effect == E_Effect.EE_UltraDoubleJudge then  --奥特双重裁决
		if data.passive_condition == E_PSKILLCONDITIONS.EPC_BATTLE_START then
			Anomalyid = E_Anomaly.EA_UltraDoubleJudge
			local teamType = card:getMatchCardData():getTeam()
			local cards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(cards)
			if #cards <= 0 then return end
			
			local psSkillId = 976
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			for k, v in pairs(cards) do
				v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, indexSole, nil, nil, cid, psSkillId, sid)
				v:getMatchCardCCBI():addBuff(Anomalyid)
				v:showWenZi(data.effect, data.effmainparam)
				v:getMatchCardCCBI():updateAnomalyShow()
				
				if v:getMatchCardSkill():addPSkillID(psSkillId) then
					local skilldata = v:getMatchCardSkill():initPaSkillDatasById(psSkillId)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					v:getMatchCardSkill():pushBack(skilldata)
				end
			end
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, Anomalyid, cards[1]:getMatchCardData():getTeam(), false, psSkillId)
		elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_ROLE_STEP_START then
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_UltraDoubleJudge)
			local cid, sid = anomalyData[1].cid, anomalyData[1].sid
			local teamType = card:getMatchCardData():getTeam()
			local fury = card:getMatchCardData():getFury()
			local targetAttr = {}
			local showWenziFunc = nil
			if fury % 2 == 0 then --偶数：超越之钥
				Anomalyid = E_Anomaly.EA_KeyOfTranscend
				showWenziFunc = MatchEffect.keyOfTranscend
				targetAttr = {
					E_Anomaly.EA_PhysicalDefAdd, E_Anomaly.EA_CritDamageFreeAdd,
					E_Anomaly.EA_DamageFreeAdd, E_Anomaly.EA_DamageFreePercent
				}
			else  --奇数：奥特次元
				Anomalyid = E_Anomaly.EA_UltraDimension
				showWenziFunc = MatchEffect.ultraDimension
				targetAttr = {
					E_Anomaly.EA_AttackAdd, E_Anomaly.EA_CritDamageAdd,
					E_Anomaly.EA_AllDamageAdd, E_Anomaly.EA_SkillPowerUp
				}
			end
			
			local attrlist = {}
			local tAnomalData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)		
			if not tAnomalData or #tAnomalData == 0 then
				attrlist = targetAttr
			elseif tAnomalData and #tAnomalData < #targetAttr then
				for _, attr in ipairs(targetAttr) do
					local flag = false
					for i = 1, #tAnomalData do
						if attr == tAnomalData[i].condition_param then
							flag = true
							break
						end
					end
					if not flag then
						table.insert(attrlist, attr)
					end
				end
			end
			
			if #attrlist > 0 then
				math.randomseed(tostring(os.time()):reverse():sub(1, 6))
				local randIndex = math.random(1, #attrlist)
				local param = attrlist[randIndex]
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, cid, param, sid)
				card:getMatchCardCCBI():addBuff(Anomalyid)
				local _posx, _posy = MatchFunction:getMatchCardPosition(card)
				showWenziFunc(self, ccp(_posx, _posy))
				card:getMatchCardCCBI():updateAnomalyShow()
				
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, Anomalyid, teamType, false)
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_ShieldAndSword then  --德凯盾剑
		Anomalyid = E_Anomaly.EA_ShieldAndSword
		if card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_ShieldMode)
			card:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_SwordMode)
			local attack = card:getMatchCardDataAdd():getAttack()
			local physDefense = card:getMatchCardDataAdd():getPhysDefense()
			local specialDefense = card:getMatchCardDataAdd():getSpecialDefense()
			local defense = physDefense + specialDefense
			local showWenziFunc = nil
			local cardId = 0
			if defense >= attack then  --<盾牌模式>
				Anomalyid = E_Anomaly.EA_ShieldMode
				showWenziFunc = MatchEffect.shieldMode
				cardId = 404
			else --<利剑模式>
				Anomalyid = E_Anomaly.EA_SwordMode
				showWenziFunc = MatchEffect.swordMode
				cardId = 40401
			end
			card:getMatchCardCCBI():updateAnomalyBuffArmature()
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, data.conditionparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			local _posx, _posy = MatchFunction:getMatchCardPosition(card)
			showWenziFunc(self, ccp(_posx, _posy))
			card:getMatchCardCCBI():updateAnomalyShow()
			card:getMatchCardCCBI():getMatchCardHeadImage():changeHeadImage(cardId)
		else
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, 0)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(975) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(975)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
			
		end
		return
		
	elseif data.effect == E_Effect.EE_LegendShined then  --传说闪亮复合
		Anomalyid = E_Anomaly.EA_LegendShined
		if card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			Anomalyid = E_Anomaly.EA_DimensionForce
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			if not anomalyData or #anomalyData < 3 then
				for i = 1, 3 do
					card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, 0)
				end				
				local _posx, _posy = MatchFunction:getMatchCardPosition(card)
				MatchEffect:dimensionForce(ccp(_posx, _posy))
				card:getMatchCardCCBI():addBuff(Anomalyid)
				card:getMatchCardCCBI():updateAnomalyShow()
			end
		else
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			if card:getMatchCardSkill():addPSkillID(974) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(974)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_Demarches then  --合纵连横
		if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Demarches) then
			Anomalyid = E_Anomaly.EA_Demarches
			local cards = {}
			local uidList = {389, 385}
			local teamType = card:getMatchCardData():getTeam()
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			for k, uid in ipairs(uidList) do
				for _, v in ipairs(teamCards) do
					local uniqId = v:getMatchCardForm():getUniqueid()
					if uniqId == uid then
						table.insert(cards, v)
					end
				end
				if #cards > 0 then
					break
				end
			end
			
			if #cards > 0 then
				table.sort(cards, function(a, b)
					return 	a:getMatchCardData():getAttack() > b:getMatchCardData():getAttack()
				end)
				local target = cards[1]
				local cid1 = card:getMatchCardForm():getCID()
				local sid1 = card:getMatchCardData():getSID()
				local cid2 = target:getMatchCardForm():getCID()
				local sid2 = target:getMatchCardData():getSID()
				
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, cid1, sid1, {sid1, sid2})
				card:showWenZi(data.effect, data.effmainparam)
				card:getMatchCardCCBI():addBuff(Anomalyid)
				card:getMatchCardCCBI():updateAnomalyShow()
				local basic1 = card:getMatchCardSkill():getSkill_Basic()
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_DemarchesExt, 15, basic1, false, 0, nil, nil, cid1, sid1, {sid1, sid2})
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid1, Anomalyid, teamType, false, 973)
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid1, E_Anomaly.EA_DemarchesExt, teamType)
				
				target:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, cid2, sid1, {sid1, sid2})
				target:showWenZi(data.effect, data.effmainparam)
				target:getMatchCardCCBI():addBuff(Anomalyid)
				target:getMatchCardCCBI():updateAnomalyShow()
				local basic2 = target:getMatchCardSkill():getSkill_Basic()
				target:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_DemarchesExt, 15, basic2, false, 0, nil, nil, cid2, sid1, {sid1, sid2})
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid2, Anomalyid, teamType, false, 973)
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid2, E_Anomaly.EA_DemarchesExt, teamType)
				
				if card:getMatchCardSkill():addPSkillID(973) then
					local skilldata = card:getMatchCardSkill():initPaSkillDatasById(973)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					card:getMatchCardSkill():pushBack(skilldata)
				end
				
				if target:getMatchCardSkill():addPSkillID(973) then
					local skilldata = target:getMatchCardSkill():initPaSkillDatasById(973)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					target:getMatchCardSkill():pushBack(skilldata)
				end
			end
		elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_POWER_SKILL then
			local partner = nil
			local teamType = card:getMatchCardData():getTeam()
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			for _, v in pairs(teamCards) do
				if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Demarches) and
					card:getMatchCardData():getCID() ~= v:getMatchCardData():getCID() then
					partner = card
					break
				end
			end
			assert(partner, "Error:合纵连横缺少另一伙伴")
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_Demarches)
			data.effect = E_Effect.EE_Initiative
			if card:getMatchCardData():getSID() == anomalyData[1].condition_param then
				onEffect(partner, data)
			else
				data.effmainparam = data.conditionparam
				onEffect(card, data)
			end
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_DemarchesExt)
			anomalyData[1].mark = 0
		end
		
		return
		
		
	elseif data.effect == E_Effect.EE_TimeSpaceCrack then --时空裂痕
		Anomalyid = E_Anomaly.EA_TimeSpaceCrack
		if data.conditionparam > 0 and card:getMatchAnomaly():isAnomalyByType(Anomalyid) then			
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local base = card:getMatchCardData():getCrit()
			base = data.conditionparam == 1 and base or 1
			local maxValue = 3 * data.effmainparam * base
			if math.abs(anomalyData[data.conditionparam].mark) < math.abs(maxValue) then
				anomalyData[data.conditionparam].mark = anomalyData[data.conditionparam].mark + data.effmainparam * base
			else
				anomalyData[data.conditionparam].mark = maxValue
			end
			card:showWenZi(data.effect, data.effmainparam)
		else
			local cid = card:getMatchCardData():getCID()
			local sid = card:getMatchCardData():getSID()
			local indexSole = card:getMatchCardData():getIndexSole()
			local teamType = card:getMatchCardData():getTeam()
			local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(oppoCards)
			
			for k, v in pairs(oppoCards) do
				v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, nil, sid)
				v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, nil, sid)
				v:showWenZi(data.effect, data.effmainparam)
				v:getMatchCardCCBI():addBuff(Anomalyid)
				v:getMatchCardCCBI():updateAnomalyShow()
				
				if v:getMatchCardSkill():addPSkillID(972) then
					local skilldata = v:getMatchCardSkill():initPaSkillDatasById(972)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					v:getMatchCardSkill():pushBack(skilldata)
				end
			end
			
			local opopTeamType = teamType == E_MATCH.TEAM_MY and E_MATCH.TEAM_OPPO or E_MATCH.TEAM_MY
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, Anomalyid, opopTeamType, false, 972)			
		end
		
		return
		
	elseif data.effect == E_Effect.EE_TimeSpaceJump then  --时空跃迁
		Anomalyid = E_Anomaly.EA_TimeSpaceJump
		if card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)			
			if data.passive_condition == E_PSKILLCONDITIONS.EPC_MAINSKILL_ATTACK then
				local teamType = card:getMatchCardData():getTeam()
				local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
				oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(oppoCards)
				local maxValue = data.effmainparam * 10
				for k, v in pairs(oppoCards) do
					if anomalyData[1].mark >= maxValue then
						break
					end
					if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_TimeSpaceCrack) then
						anomalyData[1].mark = anomalyData[1].mark + data.effmainparam
					end
				end
			elseif data.passive_condition == E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE then
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, 1, 1, false)
				MatchRunAction:delayTime(function()
					local value = card:getMatchCardData():getHPMax()
					card:setHP(value)
					card:getMatchAnomaly():cleanAllDebuffAndAnomaly()
				end, 0.5)
			end
		else
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			if card:getMatchCardSkill():addPSkillID(971) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(971)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
		
		return

	elseif data.effect == E_Effect.EE_Annihilate then  --湮灭
		Anomalyid = E_Anomaly.EA_Annihilate
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local team = card:getMatchCardData():getTeam()
			local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(team)
			for k, v in pairs(teamCards) do
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			end
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(970) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(970)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local team = card:getMatchCardData():getTeam()
			local oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(team)
			oppoTeams = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoTeams)
			if #oppoTeams > 0 then
				for k, v in pairs(oppoTeams) do
					if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Chaos) then
						card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
					end
				end
				card:showWenZi(data.effect, data.effmainparam)
				card:getMatchCardCCBI():addBuff(Anomalyid)
				card:getMatchCardCCBI():updateAnomalyShow()
			end
		end
		return
		
	elseif data.effect == E_Effect.EE_SuperZhidunBarrier then  --超级芝顿屏障
		Anomalyid = E_Anomaly.EA_SuperZhidunBarrier
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local count = data.conditionparam
			for i = 1, count do
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, count, nil, nil, nil, 0)
			end
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(949) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(949)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end 
			
		elseif data.conditionparam == 1 then
			local feignDeathData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_FeignDeath)
			if feignDeathData and #feignDeathData > 0 then
				for k, v in pairs(feignDeathData) do
					if v.condition_param and v.condition_param == Anomalyid then
						--移除上一次致命保留的值
						table.remove(feignDeathData, k)
						break
					end
				end
			end
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			if anomalyData[1].condition_param > 0 then
				local value = card:getMatchCardData():getHP() - 1				
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, value, false, nil, nil, nil, nil, Anomalyid)
				anomalyData[1].condition_param = anomalyData[1].condition_param - 1
			end
		elseif data.conditionparam == 2 then
			if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_FeignDeath) then
				local value = card:getMatchCardData():getHP() - 1
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, value, false)
			end
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Defense, data.effoffparam, data.effmainparam, false)
			card:getMatchCardCCBI():addBuff(E_Anomaly.EA_Defense)
			card:getMatchCardCCBI():updateAnomalyShow()
			local _posx, _posy = MatchFunction:getMatchCardPosition(card)
			MatchEffect:invincible(ccp(_posx, _posy))
		end
		
		return
		
	elseif data.effect == E_Effect.EE_DeathOverture then  --灭亡序曲
		Anomalyid = E_Anomaly.EA_DeathOverture			
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local teamType = card:getMatchCardData():getTeam()
			local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
			local sid = card:getMatchCardData():getSID()
			local cid = card:getMatchCardData():getCID()
			for k, v in pairs(oppoCards) do
				v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0, nil, nil, cid, card, sid)
				v:showWenZi(data.effect, data.effmainparam)
				v:getMatchCardCCBI():addBuff(Anomalyid)
				v:getMatchCardCCBI():updateAnomalyShow()
				
				if v:getMatchCardSkill():addPSkillID(969) then
					local skilldata = v:getMatchCardSkill():initPaSkillDatasById(969)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					v:getMatchCardSkill():pushBack(skilldata)
				end
			end
			
			local oppoTeam = oppoCards[1]:getMatchCardData():getTeam()
			MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, E_Anomaly.EA_DeathOverture, oppoTeam, false, 969)
			
		elseif card:getMatchCardData():getIsLive() and card:getMatchCardForm():getAttribute() == E_MATCH.ATTRIBUTE_PLAYER then
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local value = math.abs(data.effmainparam) * data.conditionparam
			if math.abs(anomalyData[1].mark) < value then
				anomalyData[1].mark = anomalyData[1].mark + data.effmainparam
			end
			card:showWenZi(data.effect)
		elseif not card:getMatchCardData():getIsLive() then
			--死亡后触发
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local targetCard = anomalyData[1].condition_param
			
			local _attack = card:getMatchCardData():getAttack() * 0.5
			local _physicalDefense = card:getMatchCardData():getPhysDefense() * 0.5
			local _specialDefense = card:getMatchCardData():getSpecialDefense() * 0.5
			
			local _attackMax = math.floor(targetCard:getMatchCardData():getAttack() * data.effmainparam / 100)
			local _physicalDefenseMax = math.floor(targetCard:getMatchCardData():getPhysDefense() * data.effmainparam / 100)
			local _specialDefenseMax = math.floor(targetCard:getMatchCardData():getSpecialDefense() * data.effmainparam / 100)
			
			_attack = _attack <= _attackMax and _attack or _attackMax
			_physicalDefense = _physicalDefense <= _physicalDefenseMax and _physicalDefense or _physicalDefenseMax
			_specialDefense = _specialDefense <= _specialDefenseMax and _specialDefense or _specialDefenseMax
					
			targetCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_AttackAdd, data.effoffparam, _attack, false)
			targetCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PhysicalDefAdd, data.effoffparam, _physicalDefense, false)
			targetCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_SpecialDefAdd, data.effoffparam, _specialDefense, false)
			
			local teamType = targetCard:getMatchCardData():getTeam()
			local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			for k, v in pairs(cards) do
				local value = math.floor(targetCard:getMatchCardData():getHPMaxRec() * data.conditionparam)
				local currHp = v:getMatchCardData():getHP()
				local hpMax = v:getMatchCardData():getHPMax()
				local recoverHp = hpMax - currHp
				recoverHp = value >= recoverHp and recoverHp or value
				v:setHP(recoverHp)
				--显示文字
				local _posx, _posy = MatchFunction:getMatchCardPosition(v)
				MatchEffect:recover_small(ccp(_posx, _posy), recoverHp)
				MatchLog:getInstance():locateCardMsgByIndexSole(v:getMatchCardData():getIndexSole())
				MatchLog:getInstance():setCardMsgInfo("effectType", EFFECTTYPE.RECOVERHP)
				MatchLog:getInstance():setCardMsgInfo("changeHp", recoverHp)
			end
			
			if card:getMatchCardSkill():havePSkillID(969) then
				card:getMatchCardSkill():removeSkillById(969)
				card:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
				card:getMatchCardCCBI():updateAnomalyShow()
			end
		end

		return
	
	elseif data.effect == E_Effect.EE_DistortAbyss then  --扭曲深渊
		Anomalyid = E_Anomaly.EA_DistortAbyss
		local teamType = card:getMatchCardData():getTeam()
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		local pMatchStepMid = MatchCtrl:getInstance():getMatchStepMid()
		local count = 0
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			count = #cards
		elseif pMatchStepMid and pMatchStepMid:getMatchStepMidData():checkMainSkillPhase() then
			count = E_MATCH.CONST_MEMBER_MAX - #cards
		end
		if count > 0 then
			for i = 1, count do
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			end
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			if card:getMatchCardSkill():addPSkillID(968) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(968)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
		return
		
	elseif data.effect == E_Effect.EE_CurseSuppress then  --诅咒抑制
		Anomalyid = E_Anomaly.EA_CurseSuppress
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local allCards = MatchCtrl:getInstance():getMatchCardCtrl():getAllCards()
			local totalAtkValue = 0
			for k, v in pairs(allCards) do
				if v:getMatchCardData():getIsVaild() then
					totalAtkValue = totalAtkValue + v:getMatchCardData():getAttack()
				end
			end
			totalAtkValue = math.floor(totalAtkValue * data.effmainparam / 100)
			local totalAtkMax = math.floor(card:getMatchCardData():getAttack() * data.conditionparam / 100)
			totalAtkValue = totalAtkValue < totalAtkMax and totalAtkValue or totalAtkMax
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, totalAtkValue, false, 1)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
		else
			local temp = {
				{buff = E_Anomaly.EA_PowerZeda, showWenziFunc = MatchEffect.powerZeda, triggerSkillId = 967},  --宙达之力 222
				{buff = E_Anomaly.EA_PowerMolde, showWenziFunc = MatchEffect.powerMolde, triggerSkillId = 966}, --莫尔德  223
				{buff = E_Anomaly.EA_PowerGina, showWenziFunc = MatchEffect.powerGina, triggerSkillId = 965}  --吉娜  224
			}
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].condition_param = anomalyData[1].condition_param or {}
			
			local bufflist = {}
			for k, v in pairs(temp) do
				if not G_if_var_in(v.buff, anomalyData[1].condition_param) then
					table.insert(bufflist, v)
				end
			end
			
			if #bufflist > 0 then
				local rand = math.random(1, #bufflist)	
				table.insert(anomalyData[1].condition_param, bufflist[rand].buff)
				local buffType = bufflist[rand].buff
				card:getMatchAnomaly():setAnomalyByType(buffType, data.effoffparam, data.effmainparam, false)			
				local _posx, _posy = MatchFunction:getMatchCardPosition(card)
				bufflist[rand].showWenziFunc(self, ccp(_posx, _posy))
				card:getMatchCardCCBI():addBuff(buffType)
				card:getMatchCardCCBI():updateAnomalyShow()
				
				if card:getMatchCardSkill():addPSkillID(bufflist[rand].triggerSkillId) then
					local skilldata = card:getMatchCardSkill():initPaSkillDatasById(bufflist[rand].triggerSkillId)--小于1000的是程序专用技能ID,这里999用于给对方叠加
					card:getMatchCardSkill():pushBack(skilldata)
				end
				
				--用于技能替换和图片ID替换
				if #bufflist == 1 then
					local cid = card:getMatchCardData():getCID()
					local rank = get_st_bcardinfo_value(cid, "rank")
					local skillData = rank <= 15 and {basicId = 38695, fullId = 38696} or {basicId = 1638695, fullId = 1638696}					
					card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_CurseSuppressExt, 15, 1, false, nil, nil, nil, nil, skillData)
					card:getMatchCardCCBI():getMatchCardHeadImage():changeHeadImage(40801)
				end
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_EmperorsPower then  --帝王之威
		Anomalyid = E_Anomaly.EA_EmperorsPower
		local sid = card:getMatchCardData():getSID()
		local cid = card:getMatchCardData():getCID()
		local teamType = card:getMatchCardData():getTeam()
		local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		
		local baseCritAnti = card:getMatchCardData():getCritMultipleAnti()
		local count = math.floor((baseCritAnti - 1) * 10)
		count = count > 0 and count or 0
		local value = count * 5
		value = value <= 50 and value or 50 
		for k, v in pairs(cards) do
			v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, value, nil, nil, cid, nil, sid)
			v:showWenZi(data.effect, data.effmainparam)
			v:getMatchCardCCBI():addBuff(Anomalyid)
			v:getMatchCardCCBI():updateAnomalyShow()
		end
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, Anomalyid, teamType)
		return
		
	elseif data.effect == E_Effect.EE_SoulCursePressing then --灵咒制压
		Anomalyid = E_Anomaly.EA_SoulCursePressing
		local teamType = card:getMatchCardData():getTeam()
		local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
		oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCards(oppoCards)
		
		local hpRec = card:getMatchCardData():getHPMaxRec()
		local value = math.floor(hpRec * data.effmainparam / 100)
		for k, v in pairs(oppoCards) do
			if v:getMatchCardForm():getAttribute() == E_MATCH.ATTRIBUTE_MONSTER then
				value = data.conditionparam				
			end
			v:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
			v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, value, false)
			v:showWenZi(data.effect, data.effmainparam)
			v:getMatchCardCCBI():addBuff(Anomalyid)
			v:getMatchCardCCBI():updateAnomalyShow()
		end
		return
		
	elseif data.effect == E_Effect.EE_EnergyCore then  --光辉能量核心
		Anomalyid = E_Anomaly.EA_EnergyCore
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0)
			if card:getMatchCardSkill():addPSkillID(964) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(964)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local value = card:getMatchCardData():getHP() - 1
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, value, false)
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].mark = card:getMatchCardData():getHPMaxRec()
			anomalyData[1].condition_param = 1
			return
		end
		
	elseif data.effect == E_Effect.EE_QuickRecover then  --急速恢复
		Anomalyid = E_Anomaly.EA_QuickRecover
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(961) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(961)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].condition_param = data.effmainparam
			local recoverHp = card:getMatchCardData():getHPMax()
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, 1, recoverHp, false)
		end
		return
	elseif data.effect == E_Effect.EE_LimitFullOpen then  --极限全开	
		Anomalyid = E_Anomaly.EA_LimitFullOpen
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()

			if card:getMatchCardSkill():addPSkillID(960) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(960)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].condition_param = (anomalyData[1].condition_param or 0) + data.effmainparam
		end
		
		return
		
	elseif data.effect == E_Effect.EE_NewExplosion then  --新生代爆炸
		Anomalyid = E_Anomaly.EA_NewExplosion
		if not card:getMatchAnomaly():getAnomalyByType(Anomalyid) and data.conditionparam > 0 then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, nil, data.conditionparam)
			if card:getMatchCardSkill():addPSkillID(959) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(959)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local newDawnData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NewDawn)
			local newExplosionData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NewExplosion)
			if newDawnData and newExplosionData and #newDawnData == newExplosionData[1].condition_param then
				for i = 1, 5 do
					card:getMatchAnomaly():cleanOnceAnomalyByType(E_Anomaly.EA_NewDawn)
				end
				data.effect = E_Effect.EE_Initiative
				onEffect(card, data)
			end
			return
		end
			
	elseif data.effect == E_Effect.EE_NewDawn then  --新生曙光
		Anomalyid = E_Anomaly.EA_NewDawn
		local newDawnData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
		local newExplosionData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_NewExplosion)
		if newDawnData and #newDawnData >= newExplosionData[1].condition_param then
			return
		end
		
		card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
		if data.conditionparam > 0 and goalCard then
			local uid = goalCard:getMatchCardForm():getUniqueid()
			if MatchFormation:checkIsNewRebirthRole(uid) then
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			end
		end
		--要保证不能超出10层
		newDawnData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
		local count = #newDawnData - newExplosionData[1].condition_param
		count = count >= 0 and count or 0
		for i = 1, count do
			card:getMatchAnomaly():cleanOnceAnomalyByType(Anomalyid)
		end
		
		--注意:新生曙光的值 用新生代爆炸 去记录和使用
		local value = card:getMatchAnomaly():getDataAddByType(Anomalyid)
		if newExplosionData[1].value < value then
			newExplosionData[1].value = value
		end
		
	elseif data.effect == E_Effect.EE_PhantomBeastsRealm then  --幻兽之界的buff还原
		local teamType = card:getMatchCardData():getTeam()
		local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
		oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
		for k,v in pairs(oppoCards) do
			if not v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Delay) and
				not v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_PhantomBeastsRealm) then
				--还原buff
				v:getMatchAnomaly():regainCurBuffAnomaly()
				v:getMatchCardCCBI():updateAnomalyShow()
				v:getMatchCardSkill():removePSkillID(958)
			end
		end
		return
	elseif data.effect == E_Effect.EE_FlyCrane then  --飞翔之精鹤
		Anomalyid = E_Anomaly.EA_FlyCrane
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			if card:getMatchCardSkill():addPSkillID(957) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(957)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local max_value = data.conditionparam * data.effmainparam / 100
			if anomalyData[1].condition_param == nil then
				anomalyData[1].condition_param = 0
			elseif anomalyData[1].condition_param < max_value then
				anomalyData[1].condition_param = anomalyData[1].condition_param + data.effmainparam / 100
			end
			anomalyData[1].mark = data.effoffparam
			return
		end
	elseif data.effect == E_Effect.EE_FlameShock then --火炎之电击
		Anomalyid = E_Anomaly.EA_FlameShock
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			if card:getMatchCardSkill():addPSkillID(956) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(956)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		elseif data.conditionparam == 1 then
			local teamType = card:getMatchCardData():getTeam()
			local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
			local count = E_MATCH.CONST_MEMBER_MAX - #oppoCards
			for i = 1, count do
				card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			end
		elseif data.conditionparam == 2 then
			local info = {
				{effect = E_Effect.EE_Initiative, effoffparam = 1, effmainparam = data.effmainparam},
				{effect = E_Effect.EE_Initiative, effoffparam = 1, effmainparam = data.effoffparam}
			}
			for k, v in ipairs(info) do
				onEffect(card, v)
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_FrozenLeopard then  --高速冻豹
		Anomalyid = E_Anomaly.EA_FrozenLeopard
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			if card:getMatchCardSkill():addPSkillID(955) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(955)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		else 
			local teamType = card:getMatchCardData():getTeam()
			local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
			oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
			local value = 0
			for k, v in pairs(oppoCards) do
				if v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Frost) then
					value = value + data.effmainparam
				end
			end
			local ptrGroupCards = MatchCtrl:getInstance():getMatchStepMid():getMatchStepMidData():getEffect1PtrGroupCards()
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local randValue = value + anomalyData[1].value
			math.randomseed(tostring(os.time()):reverse():sub(1, 6))
			for k, v in pairs(ptrGroupCards) do
				local rand = math.random(1, 100)
				if rand <= randValue then
					v.m_pCard:getMatchAnomaly():cleanAnomalyByType(E_Anomaly.EA_Frost)
					local info = {nType = E_Anomaly.EA_Frost, count = data.effoffparam, value = data.effmainparam, isAtkCard = false}
					if not v.m_pCard:getMatchAnomaly():checkCtrlEffectAnomalyImmune(info) then
						v.m_pCard:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_Frost, data.effoffparam, data.effmainparam, false)
						local _posx, _posy = MatchFunction:getMatchCardPosition(v.m_pCard)
						MatchEffect:frost(ccp(_posx, _posy))
						v.m_pCard:getMatchCardCCBI():removeBuff(E_Anomaly.EA_Frost, true)
						v.m_pCard:getMatchCardCCBI():addBuff(E_Anomaly.EA_Frost)
						v.m_pCard:getMatchCardCCBI():updateAnomalyShow()
					end
				end
			end
			return
		end
	elseif data.effect == E_Effect.EE_PhantomWaterSnake then	--幻影之水蛇
		Anomalyid = E_Anomaly.EA_PhantomWaterSnake
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0)
			card:showWenZi(data.effect, data.effmainparam)
			card:getMatchCardCCBI():addBuff(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			
			if card:getMatchCardSkill():addPSkillID(954) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(954)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
			
			if card:getMatchCardSkill():addPSkillID(953) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(953)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		elseif data.conditionparam == 2 then
			local teamType = card:getMatchCardData():getTeam()
			local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
			for k, v in pairs(cards) do
				v:getMatchAnomaly():cleanDebuffByRandom(1)
				v:getMatchCardCCBI():updateAnomalyShow()
				v:getMatchCardCCBI():updateAnomalyBuffArmature()
				local _posx, _posy =  MatchFunction:getMatchCardPosition(v)
				MatchEffect:relieveDebuff(ccp(_posx, _posy))
			end			
		else
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local value = math.floor(card:getMatchCardData():getAttack() * data.effmainparam / 100)
			local maxValue = math.floor(card:getMatchCardData():getHPMaxRec() * 15 / 100)
			value = anomalyData[1].mark + value
			anomalyData[1].mark = value >= maxValue and maxValue or value
		end
		
		return
		
	elseif data.effect == E_Effect.EE_WaterSnakeTwine then	--水蛇之缠
		Anomalyid = E_Anomaly.EA_WaterSnakeTwine		
		local phyDefense = goalCard:getMatchCardData():getPhysDefense()
		local specialDefense = goalCard:getMatchCardData():getSpecialDefense()
		local addPhyDefense = math.floor(phyDefense * data.effmainparam / 100)
		local addSpecDefense = math.floor(specialDefense * data.effmainparam / 100)
		specialDefense = specialDefense + addSpecDefense
		goalCard:getMatchCardData():setPhysDefense(phyDefense + addPhyDefense)
		goalCard:getMatchCardData():setSpecialDefense(specialDefense + addSpecDefense)
		goalCard:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, addPhyDefense, false, addSpecDefense)
		goalCard:showWenZi(data.effect, addPhyDefense)
		goalCard:getMatchCardCCBI():addBuff(Anomalyid)
		goalCard:getMatchCardCCBI():updateAnomalyShow()
		
		return
	elseif data.effect == E_Effect.EE_PhantomBeastOverlord then  --幻兽之霸王
		Anomalyid = E_Anomaly.EA_PhantomBeastOverlord
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local attack = math.floor(card:getMatchCardData():getHPMaxRec() * data.effmainparam / 100)
			card:getMatchCardData():addAttack(attack)
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, 0, nil, nil, nil, attack)
			
			if card:getMatchCardSkill():addPSkillID(952) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(952)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
	elseif data.effect == E_Effect.EE_PhantomBeastSource then  --幻兽之源
		Anomalyid = E_Anomaly.EA_PhantomBeastSource
		local setAnomalyData = function(num, count, value, maxNum)
			if num > 0 then
				for i = 1, num do
					card:getMatchAnomaly():setAnomalyByType(Anomalyid, count, value, false)
				end
				card:showWenZi(data.effect, value)
				card:getMatchCardCCBI():addBuff(Anomalyid)
				card:getMatchCardCCBI():updateAnomalyShow()
			end
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			anomalyData[1].mark = anomalyData[1].mark + num
			anomalyData[1].mark = anomalyData[1].mark <= maxNum and anomalyData[1].mark or maxNum
			anomalyData[1].value = value * anomalyData[1].mark
			anomalyData[1].condition_param = 0 --统计归0
		end
		
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			--value: 属性值
			--mark: 当前层数
			--condition_param: 统计施放主动技时造成的伤害目标人数，排除<闪避> 和 <逆转> 的目标
			--condition 填 0 是为了不加入战报
			--第一层: 用于统计和标记
			-- 951 的 conditionparam2 表示了可允许的最大层数上限
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, 0, false, 0, 1)
			local pskillData = card:getMatchCardSkill():parsePassiveSkillById(951)--小于1000的是程序专用技能ID,这里999用于给对方叠加
			setAnomalyData(data.conditionparam, data.effoffparam, data.effmainparam, pskillData[2].conditionparam)
			for _, skilldata in pairs(pskillData) do
				card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_PhantomBeastSourceEx, skilldata.effoffparam, skilldata.effmainparam, false, skilldata.conditionparam)
			end
			
		elseif data.conditionparam == 1 then
			--施放主动技时
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local maxNum = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_PhantomBeastSourceEx)[2].mark --最大层数
			if #anomalyData > maxNum then
				local info = {} --先保存anomalyData[1]
				for k, v in pairs(anomalyData[1]) do
					info[k] = v
				end
				card:getMatchAnomaly():cleanAnomalyByType(Anomalyid)--清空buff
				card:getMatchAnomaly():setAnomalyByType(info.type, info.count, info.value, info.bAttacker, info.mark,
					info.condition, info.passive_condition, info.cid, info.condition_param)
			else
				local count = (#anomalyData - 1) + anomalyData[1].condition_param - maxNum
				count = count >= 0 and count or 0
				count = anomalyData[1].condition_param - count
				setAnomalyData(count, data.effoffparam, data.effmainparam, maxNum)
			end
		elseif data.conditionparam == 2 then
			--受到致命伤害时,免疫本次伤害
			local hp = card:getMatchCardData():getHP() - 1
			card:getMatchAnomaly():setAnomalyByType(E_Anomaly.EA_FeignDeath, data.effoffparam, hp, false)
			--利用幻兽之霸王记录护盾值
			local beastOverlord = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_PhantomBeastOverlord)
			beastOverlord[1].mark = card:getMatchCardData():getHPMaxRec()
			--清除所有减益效果和异常buff
			local num = card:getMatchAnomaly():getCurDebuffAnomalyType()
			if num > 0 then
				card:getMatchAnomaly():cleanDebuffByRandom(num)
				card:getMatchCardCCBI():updateAnomalyShow()
				card:getMatchCardCCBI():updateAnomalyBuffArmature()
				local _posx, _posy =  MatchFunction:getMatchCardPosition(card)
				MatchEffect:relieveDebuff(ccp(_posx, _posy))
			end
			
			--buff层数补满
			local maxNum = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_PhantomBeastSourceEx)[2].mark --最大层数
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			local count = maxNum - (#anomalyData - 1)
			local value = anomalyData[1].value / anomalyData[1].mark
			setAnomalyData(count, anomalyData[1].count, value, maxNum)
		end
	
		return
		
	elseif data.effect == E_Effect.EE_BigDipper then  --天罡
		Anomalyid = E_Anomaly.EA_BigDipper
		local teamType = card:getMatchCardData():getTeam()
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		local targetCard = MatchFormation:maxAtkAdd(teamCards)[1]
		if not targetCard:getMatchAnomaly():isAnomalyByType(Anomalyid) and data.conditionparam > 0 then
			targetCard:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			targetCard:showWenZi(data.effect, data.effmainparam)
			targetCard:getMatchCardCCBI():addBuff(Anomalyid)
			targetCard:getMatchCardCCBI():updateAnomalyShow()
			
			if targetCard:getMatchCardSkill():addPSkillID(950) then
				local skilldata = targetCard:getMatchCardSkill():initPaSkillDatasById(950)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				targetCard:getMatchCardSkill():pushBack(skilldata)
			end
		elseif card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():cleanAnomalyByType(Anomalyid)
			card:getMatchCardCCBI():updateAnomalyShow()
			card:getMatchCardSkill():removeSkillById(950)
			
			local indexSole = card:getMatchCardData():getIndexSole()
			local currCollection = MatchLog:getInstance():getCurrentCollection()
			MatchLog:getInstance():setCurrentCollection("afterAtk")
			MatchLog:getInstance():locateCardMsgByIndexSole(indexSole)
			MatchLog:getInstance():addNewBuffToCardMsg(E_Anomaly.EA_BigDipper, 0, -99, 0)
			MatchLog:getInstance():setCurrentCollection(currCollection)
		end
		
		return
		
	elseif data.effect == E_Effect.EE_GoldenBellProt then  --金钟护体
		Anomalyid = E_Anomaly.EA_GoldenBellProt
		local sid = card:getMatchCardData():getSID()
		local cid = card:getMatchCardData():getCID()
		local teamType = card:getMatchCardData():getTeam()
		local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		for k, v in pairs(teamCards) do
			v:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, nil, nil, nil, cid, nil, sid)
			v:showWenZi(data.effect, data.effmainparam)
			v:getMatchCardCCBI():addBuff(Anomalyid)
			v:getMatchCardCCBI():updateAnomalyShow()
		end		
		MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(sid, Anomalyid, teamType)
		
		return
	elseif data.effect == E_Effect.EE_AllDamageAddNotDispel then  --全伤增幅不可驱散
		Anomalyid = E_Anomaly.EA_AllDamageAddNotDispel
		card.m_pMatchAnomaly:setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
		
	elseif data.effect == E_Effect.EE_DamageFreeAddNotDispel then  --全伤减免不可驱散
		Anomalyid = E_Anomaly.EA_DamageFreeAddNotDispel
		card.m_pMatchAnomaly:setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
		
	elseif data.effect == E_Effect.EE_ShiningStrikeEx then  --闪耀破击buff, 协助主动效果之用 <1000
		local Anomalyid = E_Anomaly.EA_ShiningStrike
		if card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			if anomalyData[1].mark > 0 and data.conditionparam > 0 then
				data.effect = data.conditionparam
				onEffect(card, data, goalCard)
				return
			end
			local _matchStepMid = MatchCtrl:getInstance():getMatchStepMid()
			if _matchStepMid and _matchStepMid:getMatchStepMidData():getSkillDatas().skilltype == E_MATCH.SKILL_TYPE_FULL then
				local team = card:getMatchCardData():getTeam()
				local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(team)
				cards = MatchFormation:targetMaxCritdamage(cards)
				if cards[1]:getMatchCardData():getSID() == card:getMatchCardData():getSID() then
					local anomalyData = cards[1]:getMatchAnomaly():getAnomalyByType(Anomalyid)
					anomalyData[1].condition_param = data.effmainparam / 100
				end
			end
		end
		
		return
		
	elseif data.effect == E_Effect.EE_GoldenTangEx then  --黄金气息buff, 协助主动效果之用 <1000
		local Anomalyid = E_Anomaly.EA_GoldenTang
		if card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
			if anomalyData[1].mark > 0 and data.conditionparam > 0 then
				data.effect = data.conditionparam
				onEffect(card, data, goalCard)
				return
			end
			local _matchStepMid = MatchCtrl:getInstance():getMatchStepMid()
			if _matchStepMid and _matchStepMid:getMatchStepMidData():getSkillDatas().skilltype == E_MATCH.SKILL_TYPE_FULL then
				local team = card:getMatchCardData():getTeam()
				local cards = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(team)
				cards = MatchFormation:targetMaxCritdamage(cards)
				if cards[1]:getMatchCardData():getSID() == card:getMatchCardData():getSID() then
					local anomalyData = cards[1]:getMatchAnomaly():getAnomalyByType(Anomalyid)
					anomalyData[1].condition_param = data.effmainparam / 100
				end
			end
		end

		return
		
	elseif data.effect == E_Effect.EE_HellInflamation then  --地狱烈炎
		local Anomalyid = E_Anomaly.EA_HellInflamation
		if not card:getMatchAnomaly():isAnomalyByType(Anomalyid) then
			card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false)
			
			if card:getMatchCardSkill():addPSkillID(936) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(936)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end	
			
			if card:getMatchCardSkill():addPSkillID(935) then
				local skilldata = card:getMatchCardSkill():initPaSkillDatasById(935)--小于1000的是程序专用技能ID,这里999用于给对方叠加
				card:getMatchCardSkill():pushBack(skilldata)
			end
		end
	elseif data.effect == E_Effect.EE_Infect then  --侵染
		local Anomalyid = E_Anomaly.EA_Infect
		local anomalyData = card:getMatchAnomaly():getAnomalyByType(Anomalyid)
		local ownCount = anomalyData and #anomalyData or 0
		if data.conditionparam > 0 then
			local maxValue = card:getMatchCardData():getEnergyAddRec()
			maxValue = maxValue <= data.conditionparam and maxValue or data.conditionparam
			local count = maxValue - ownCount
			if count > 0 then
				for i = 1, count do
					card:getMatchAnomaly():setAnomalyByType(Anomalyid, data.effoffparam, data.effmainparam, false, data.conditionparam)
				end
			end
		elseif anomalyData and ownCount >= anomalyData[1].mark then
			data.effect = E_Effect.EE_Initiative
			onEffect(card, data)
			return
		end
	elseif data.effect == E_Effect.EE_LimitSealing then  --极限封印 LimitSealing
		local teamType = card:getMatchCardData():getTeam()
		local oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
		oppoCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(oppoCards)
		for k,v in pairs(oppoCards) do
			if not v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Delay) and
				not v:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_LimitSealing) then
				--还原buff
				v:getMatchAnomaly():regainCurBuffAnomaly()
				v:getMatchCardCCBI():updateAnomalyShow()
				v:getMatchCardSkill():removePSkillID(934)
			end
		end
		return
	end

	--[[相关表现效果处理]]
	if MatchCtrl:getInstance():getIsSkip() == true then
		return
	end

	local bAdd = false;
	if data.effmainparam > 0 then
		bAdd = true;
	end

	if Anomalyid ~= E_Anomaly.EA_SupportOfForce and 
	   Anomalyid ~= E_Anomaly.EA_EvilTemptation and 
	   Anomalyid ~= E_Anomaly.EA_DataHacking and 
	   Anomalyid ~= E_Anomaly.EA_ResentmentErosion and
	   Anomalyid ~= E_Anomaly.EA_DarkField and
	   Anomalyid ~= E_Anomaly.EA_Awaking and
	   Anomalyid ~= E_Anomaly.EA_Reverse and
	   Anomalyid ~= E_Anomaly.EA_ReviveAll and
	   Anomalyid ~= E_Anomaly.EA_AtomicCore and
	   Anomalyid ~= E_Anomaly.EA_DieRuined then
		card.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
		card:showWenZi(data.effect, data.effmainparam);
		card.m_pMatchCardCCBI:updateAnomalyShow();
	end
	--由于异常buff都是加在card上的，ProbabilityHandle除外，所以此处不应该把效果文字显示在goalCard上
	-- if goalCard then
	-- 	for k, v in ipairs(goalCard) do 
	-- 		v.m_pMatchCardCCBI:addBuff(Anomalyid, bAdd);
	-- 		v:showWenZi(data.effect, data.effmainparam);
	-- 		v.m_pMatchCardCCBI:updateAnomalyShow();
	-- 	end
	-- end

end

function transformFaction(param)
	local condition1 = math.modf(param/1000)
	local condition2 = math.modf((param%1000)/100)
	local condition3 = math.modf((param%1000%100)/10)
	local condition4 = param%1000%100%10

	return condition1,condition2,condition3,condition4;
end

--前x次攻击被动(buff施加目标为攻击卡牌自身)
local XAttackHandle = function ( card, goalCard )
	-- body
	print("-----------XAttackHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_ATTACK);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			print("card.m_nAttackCount=", card:getMatchCardData().m_nAttackCount, "  v.conditionparam=",v.conditionparam)
			if card:getMatchCardData().m_nAttackCount < v.conditionparam then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--前x次受到攻击被动
local XAttackedHandle = function ( card, goalCard )
	-- body
	print("-----------XAttackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			print("card:getMatchCardData().m_nTargetedCount=", card.m_pMatchCardData.m_nTargetedCount, "  v.conditionparam=",v.conditionparam)
			if card.m_pMatchCardData.m_nTargetedCount < v.conditionparam then
			    --条件满足，产生被动效果
			    card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--受到攻击被动
local attackedHandle = function ( card, goalCard )
	-- body
	print("-----------attackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

--受到能量攻击被动
local powerAttackedHandle = function ( card, goalCard )
	-- body
	print("-----------powerAttackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if card:getMatchCardData():getIsLive() == true then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--受到治疗被动
local beenTreatmentHandle = function ( card, goalCard )
	-- body
	print("-----------beenTreatmentHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_BEEN_TREATMENT);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--死亡后被动
local deadHandle = function ( card, goalCard )
	-- body
	print("-----------deadHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_DEAD);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end

	print("-----------deadSelfTeamHandle---------")
	local selfTeam = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(card:getMatchCardData():getTeam());
	for i,v in ipairs(selfTeam) do		
		local data = v.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_DEAD_SELF_TEAM);
		if next(data) ~= nil then
			for _, passiveData in pairs(data) do
				--条件满足，产生被动效果
				v.m_pMatchCardSkill:reduceTimes(passiveData.passiveid, passiveData.flag);
				onEffect(v, passiveData);
			end
		end
	end
end

--击杀被动
local killHandle = function ( card, goalCard )
	-- body
	print("-----------killHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_KILL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--闪避触发
local evasionHandle = function ( card, goalCard )
	-- body
	print("-----------evasionHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_EVASION);
	local isShackles = card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Shackles) --判定当前是否被束缚了
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if isShackles and v.effect == E_Effect.EE_Initiative then
				print("当前被束缚了, 闪避触发的主动技(包括伤害和治疗)都不执行")
			else
				--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--格挡触发
local parryHandle = function ( card, goalCard )
	-- body
	print("-----------parryHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_PARRY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

--能量技触发
local powerSkillHandle = function ( card, goalCard )
	-- body
	print("-----------powerSkillHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			else
				if next(goalCard) ~= nil then
					for i,j in pairs(goalCard) do
						
					-- if 闪避 then
						if j.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
							card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(card, v, {goalCard[i]});
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(card, v, {goalCard[i]});
							end
						end
					end
				end
			end
			-- end
		end
	end
end

--自身生命判断
local myselfLifeHandle = function ( card, goalCard )
	-- body
	print("-----------myselfLifeHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MYSELFLIFE_JUDGE);
	local HPPercentage = (card:getMatchCardDataAdd():getHP() / card:getMatchCardData():getHPMax())*100;
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if HPPercentage < v.conditionparam then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--目标生命判断
local goalLifeHandle = function ( card, goalCard )
	-- body
	print("-----------goalLifeHandle---------")
	local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOALLIFE_JUDGE);
	local HPPercentage = (card:getMatchCardDataAdd():getHP() / card:getMatchCardData():getHPMax())*100;
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				if HPPercentage < v.conditionparam then
				--条件满足，产生被动效果
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				end
			else						
				-- if 闪避 then
				if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
					--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
					if HPPercentage < v.conditionparam then
					--条件满足，产生被动效果
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					end
				else
					print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
					if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
						if HPPercentage < v.conditionparam then
						--条件满足，产生被动效果
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			end
			-- end
		end
	end
end

--目标生命比较
local goalLifeComHandle = function ( card, goalCard )
	-- body
	print("-----------goalLifeComHandle---------")
	local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOALLIFE_COMPARISON);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				if v.conditionparam == 0 then
					--自身生命小于目标生命
					if goalCard:getMatchCardDataAdd():getHP() < card:getMatchCardDataAdd():getHP() then
						--条件满足，产生被动效果
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					end
				else
					--自身生命大于目标生命
					if goalCard:getMatchCardDataAdd():getHP() > card:getMatchCardDataAdd():getHP() then
						--条件满足，产生被动效果
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					end
				end
			else						
				-- if 闪避 then
				if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
					--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
					if v.conditionparam == 0 then
						--自身生命小于目标生命
						if goalCard:getMatchCardDataAdd():getHP() < card:getMatchCardDataAdd():getHP() then
							--条件满足，产生被动效果
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					else
						--自身生命大于目标生命
						if goalCard:getMatchCardDataAdd():getHP() > card:getMatchCardDataAdd():getHP() then
							--条件满足，产生被动效果
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				else
					print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
					if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
						if v.conditionparam == 0 then
							--自身生命小于目标生命
							if goalCard:getMatchCardDataAdd():getHP() < card:getMatchCardDataAdd():getHP() then
								--条件满足，产生被动效果
								goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(goalCard, v);
							end
						else
							--自身生命大于目标生命
							if goalCard:getMatchCardDataAdd():getHP() > card:getMatchCardDataAdd():getHP() then
								--条件满足，产生被动效果
								goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(goalCard, v);
							end
						end
					end
				end
			end
			-- end
		end
	end
end

--目标中毒状态
local goalPoisonedHandle = function ( card, goalCard )
	-- body
	print("-----------goalPoisonedHandle---------")
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Poisoned) then
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_POISONED);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				else
					-- if 闪避 then
					if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
						--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else
						print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
						if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			-- end
			end
		end
	end
end

--目标灼烧状态
local goalFireHandle = function ( card, goalCard )
	-- body
	print("-----------goalFireHandle---------")
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Fire) then
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_FIRE);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				else							
					-- if 闪避 then
					if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
						--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else
						print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
						if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			-- end
			end
		end
	end
end

--目标眩晕状态
local goalGiddyHandle = function ( card, goalCard )
	-- body
	print("-----------goalGiddyHandle---------")
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Giddy) then
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_GIDDY);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				else							
					-- if 闪避 then
					if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
						--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else
						print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
						if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			-- end
			end
		end
	end
end

--目标混乱状态
local goalChaosHandle = function ( card, goalCard )
	-- body
	print("-----------goalChaosHandle---------")
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Chaos) then
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_CHAOS);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				else
					-- if 闪避 then
					if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
						--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else
						print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
						if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			-- end
			end
		end
	end
end

--目标封技状态
local goalStopSkillHandle = function ( card, goalCard )
	-- body
	print("-----------goalStopSkillHandle---------")
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_StopSkill) then
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_STOPSKILL);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				else							
					-- if 闪避 then
					if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
						--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else
						print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
						if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			-- end
			end
		end
	end
end

--目标拥有被动技能
local goalHavePSkillHandle = function ( card, goalCard )
	-- body
	print("-----------goalHavePSkillHandle---------")
	local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_HAVESKILL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				if card.m_pMatchCardSkill:havePSkillID(v.conditionparam) == true then
					--条件满足，产生被动效果
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				end
			else						
				-- if 闪避 then
				if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
					--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
					if card.m_pMatchCardSkill:havePSkillID(v.conditionparam) == true then
						--条件满足，产生被动效果
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					end
				else
					print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
					if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
						if card.m_pMatchCardSkill:havePSkillID(v.conditionparam) == true then
						--条件满足，产生被动效果
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						end
					end
				end
			end
			-- end
		end
	end
end

--目标拥有能量
local goalPowerHandle = function ( card, goalCard )
	-- body
	print("-----------goalPowerHandle---------")
	local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_POWER);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				if card:getMatchCardData():getFury() >= v.conditionparam then
					--条件满足，产生被动效果
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				end
			else
				-- if 闪避 then
				if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
					--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
					if card:getMatchCardData():getFury() >= v.conditionparam then
						--条件满足，产生被动效果
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v, {card});  -- 20201009，修复了异常类效果不生效的问题
					end
				else
					print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
					if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
						if card:getMatchCardData():getFury() >= v.conditionparam then
						--条件满足，产生被动效果
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v, {card});
						end
					end
				end
			end
			-- end
		end
	end
end

--回合开始
local roundStartHandle = function ( card, goalCard )
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ROUND_START);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--所有攻击时
local allATTACKHandle = function ( card, goalCard )
	-- body
	print("-----------allATTACKHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_All_ATTACK);
	if next(data) ~= nil then
		local function getAtkMaxCard( team, anomalyType )
			local targetCard = {};
			local markCount = 0;
			-- 检测全场印记
			for k,v in pairs(MatchCtrl:getInstance():getMatchCardCtrl():getAllCards()) do
				if v:getMatchCardData():getIsVaild() then
					-- local indexSole = card:getMatchCardData():getIndexSole();
					local teamType = card:getMatchCardData():getTeam();
					if v:getMatchCardData():getTeam() == teamType then -- 与格罗布属于同一队
						local essenceMercyMark = v:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_EssenceMercyMark);
						if essenceMercyMark ~= nil and #essenceMercyMark > 0 then
							markCount = markCount + 1;
						end
					else
						local essenceEvilMark = v:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_EssenceEvilMark);
						if essenceEvilMark ~= nil and #essenceEvilMark > 0 then
							markCount = markCount + 1;
						end
					end
				end
			end
			if markCount >= 12 then
				return targetCard;
			end
			for k,v in pairs(team) do
				if not v:getMatchAnomaly():isAnomalyByType(anomalyType) then --真谛印记不可叠加
					table.insert(targetCard, v)
				end
			end
			
			table.sort(targetCard, function(a, b)
				return a:getMatchCardDataAdd():getAttack() > b:getMatchCardDataAdd():getAttack()
			end)
			
			return targetCard;
		end
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect == E_Effect.EE_EssenceMercyMark then -- 真谛之善
				local teamType = card:getMatchCardData():getTeam();
				local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
				local teamCards = matchCardCtrl:getVaildCards(matchCardCtrl:getTeam(teamType));
				local target = getAtkMaxCard(teamCards, E_Anomaly.EA_EssenceMercyMark);
				if #target > 0 then
					for i = 1, 2 do
						if target[i] then
							card:getMatchCardData().m_bEssenceMark = true;
							onEffect(target[i], v);
						end
					end
					
				end
			elseif v.effect == E_Effect.EE_EssenceEvilMark then -- 真谛之恶
				local teamType = card:getMatchCardData():getTeam();
				local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
				local enemyTeamCards = matchCardCtrl:getVaildCards(matchCardCtrl:getOppoTeam(teamType));
				local target = getAtkMaxCard(enemyTeamCards, E_Anomaly.EA_EssenceEvilMark);
				if #target > 0 then
					for i = 1, 2 do
						if target[i] then
							onEffect(target[i], v);
						end
					end
				end
			elseif v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			else
				if next(goalCard) ~= nil then
					for i,j in pairs(goalCard) do
						-- if 闪避 then
						print("闪避值: ", j.m_iHitOrDodge)
						if j.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
							print("没闪避，被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！", v.effect, #goalCard, #goalCard)
							card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(card, v, {goalCard[i]});
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！", v.effect)
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								print("闪避，type: ", v.effect)
								card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(card, v, {goalCard[i]});
							end
						end
					end
				end
			end
			-- end
		end
	end
end

--战斗开始时 
local battleStartHandle = function ( card, goalCard )
	-- body
	print("-----------battleStartHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_BATTLE_START);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			else
				if next(goalCard) ~= nil then
					for i,j in pairs(goalCard) do
					-- if 闪避 then
						if j.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
							card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(card, v);
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(card, v);
							end
						end
					end
				end
			end
			-- end
		end
	end
end

--前X次攻击被动(buff施加目标与释放技能的第一效果攻击目标相同)
local XAttackHandleWithEffect1Target = function ( card, goalCard )
	print("-----------XAttackHandleWithEffect1Target---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_ATTACK_EFFECT1TARGET);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
				print("card.m_nAttackCount=", card:getMatchCardData().m_nAttackCount, "  v.conditionparam=",v.conditionparam)
				if card:getMatchCardData().m_nAttackCount < v.conditionparam then
					-- for _, targetCard in pairs(goalCard) do
						card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(card, v, goalCard);
					-- end
				end
			else
				print("card.m_nAttackCount=", card:getMatchCardData().m_nAttackCount, "  v.conditionparam=",v.conditionparam)
				if card:getMatchCardData().m_nAttackCount < v.conditionparam then
					for _, targetCard in pairs(goalCard) do
						if targetCard.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(card, v, {targetCard});
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and
								v.effect ~= E_Effect.EE_ProbabilityChaos and
								v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(card, v, {targetCard});
							end
						end
					end
				end
			end
			-- end
		end
	end
end

-- 二段能量技
local SpecialPowerSkillHandle = function ( card, goalCard )
	-- body
	print("-----------SpecialPowerSkillHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SPECIAL_POWER_SKILL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

-- 前X次普通技攻击
local XNorAttackHandle = function ( card, goalCard )
	-- body
	print("-----------XNorAttackHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_NORATTACK);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			print("card.m_iNorAttackCount=", card:getMatchCardData().m_iNorAttackCount, "  v.conditionparam=",v.conditionparam)
			if card:getMatchCardData().m_iNorAttackCount <= v.conditionparam then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

-- 受到致命伤害时
local FataldamageHandle = function ( card, goalCard )
	-- body
	print("-----------FataldamageHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

-- 全体异常状态
local allAnomalyHandle = function ( card, goalCard )
	-- body
	print("-----------allAnomalyHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ALL_ANOMALY);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			local value = 0
			for i,j in pairs(goalCard) do
				-- dump(goalCard)
				local anomalyID = MatchConditionCtrl:changeType(v.conditionparam)
				if j.m_pMatchCardData:getIsVaild() == true and j.m_pMatchAnomaly:isAnomalyByType(anomalyID) then
					value = v.effmainparam + value
					-- onEffect(card, v)
				end
			end
			if value ~= 0 then
				v.effmainparam = value
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v)
			end
		end
	end
end

-- 本方异常状态
local myAnomalyHandle = function ( card, goalCard )
	-- body
	print("-----------myAnomalyHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MY_ALL_ANOMALY);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			local value = 0
			for i,j in pairs(goalCard) do
				-- dump(goalCard)
				local anomalyID = MatchConditionCtrl:changeType(v.conditionparam)
				if j.m_pMatchCardData:getIsVaild() == true and j.m_pMatchAnomaly:isAnomalyByType(anomalyID) then
					value = v.effmainparam + value
					-- onEffect(card, v)
				end
			end
			if value ~= 0 then
				--v.effmainparam = value
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v)
			end
		end
	end
end

-- 敌方异常状态
local oppoAnomalyHandle = function ( card, goalCard )
	-- body
	print("-----------oppoAnomalyHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_OPPO_ALL_ANOMALY);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			local value = 0
			for i,j in pairs(goalCard) do
				local anomalyID = MatchConditionCtrl:changeType(v.conditionparam)
				if j.m_pMatchCardData:getIsVaild() == true and j.m_pMatchAnomaly:isAnomalyByType(anomalyID) then
					value = v.effmainparam + value
				end
			end
			if value ~= 0 then
				--v.effmainparam = value
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v)
			end
		end
	end
end

-- 暴击时触发
local critHandle = function ( card, goalCard )
	-- body
	print("-----------critHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_CRIT);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			local rand = math.random(1, 100)
			print("critHandle rand: ", rand, v.conditionparam)
			if rand <= v.conditionparam then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

-- 自身每有一点能量（释放能量技时）
local selfPowerHandle = function ( card, goalCard )
	-- body
	print("-----------selfPowerHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			--最大加成12点能量
			local curFury = card:getMatchCardData():getFury();
			-- 策划要求对赛迦单独处理
			if card:getMatchCardData():getCID() > 1560 and card:getMatchCardData():getCID() < 1581 then
				curFury = ((curFury > 12) and 12) or curFury;
			end
			v.effmainparam = v.effmainparam * curFury
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
		end
	end
end

-- 自身每有一点能量（受到攻击技时）
local selfPowerAttackHandle = function ( card, goalCard )
	-- body
	print("-----------selfPowerAttackHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER_ATTACKED);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			local curFury = card:getMatchCardData():getFury();
			-- 策划要求对赛迦单独处理
			if card:getMatchCardData():getCID() > 1560 and card:getMatchCardData():getCID() < 1581 then
				curFury = ((curFury > 12) and 12) or curFury;
			end
			v.effmainparam = v.effmainparam * curFury
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
		end
	end
end

-- 自身每有一点能量（普通技攻击时）
local selfPowerNorAttackHandle = function ( card, goalCard )
	-- body
	print("-----------selfPowerAttackHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER_NORATTACK);

	if next(data) ~= nil then
		for k,v in pairs(data) do
			v.effmainparam = v.effmainparam * card:getMatchCardData():getFury()
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
		end
	end
end

-- 目标异常状态
local goalAnomalyHandle = function ( card, goalCard )
	-- body
	print("-----------goalAnomalyHandle---------")
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_ANOMALY);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				local anomalyID = MatchConditionCtrl:changeType(v.conditionparam)
				--print("SPATIAL_WARP:   ", anomalyID, card:getMatchCardData():getIndexSole(), card.m_pMatchAnomaly:isAnomalyByType(anomalyID))
				if card.m_pMatchAnomaly:isAnomalyByType(anomalyID) then
					-- if then
					--条件满足，产生被动效果
					if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else							
						-- if 闪避 then
						if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(goalCard, v);
							end
						end
					end
				-- end
				end
			end
		end
end

--回合开始
local XRoundHandle = function ( card, goalCard )
	-- body
	print("-----------XRoundHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_ROUND);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			print("-----------XRoundHandle---------: ", v.conditionparam, card:getMatchCardData():getMatchRoundCount())
			if v.conditionparam <= card:getMatchCardData():getMatchRoundCount() then
				--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v)
			end
			-- end
		end
	end
end

--目标闪避时
local goalEvasionHandle = function ( card, goalCard )
	-- body
	print("-----------goalEvasionHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_EVASION);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
			-- end
		end
	end
end

--目标格挡时
local goalParryHandle = function ( card, goalCard )
	-- body
	print("-----------goalParryHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_PARRY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
			-- end
		end
	end
end

--自身特殊buff次数判断(满足次数后移除buff)
local XmyselfSpecialbuffHandle = function ( card, goalCard )
	-- body
	print("-----------XmyselfSpecialbuffHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_X_MYSELF_SPECIALBUFF);
	if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SpecialBuff) then
		local specialBuff = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_SpecialBuff)
		if next(data) ~= nil then
			for k, v in pairs(data) do
				-- if then
				--条件满足，产生被动效果
				print("XmyselfSpecialbuffHandle--------------: ", #specialBuff, v.conditionparam)
				if #specialBuff >= v.conditionparam then
				--条件满足，产生被动效果
					--满足条件后，移除特殊buff
					card.m_pMatchAnomaly:cleanAnomalyByType(E_Anomaly.EA_SpecialBuff)

					card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(card, v);
				end
			end
		end
	end
end

-- 普通技攻击
local NorAttackHandle = function ( card, goalCard )
	-- body
	print("-----------NorAttackHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_NORATTACK);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

--每回合第1次受能量技攻击时
local firstPowerAttackedHandle = function ( card, goalCard )
	-- body
	print("-----------firstPowerAttackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_FIRST_POWER_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if card:getMatchCardData():getIsLive() == true then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--每回合第1次受能量技攻击后
local afterFirstPowerAttackedHandle = function ( card, goalCard )
	-- body
	print("-----------afterFirstPowerAttackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_AFTER_FIRST_POWER_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if card:getMatchCardData():getIsLive() == true then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, goalCard);
			end
		end
	end
end

--战斗开始时·每有1名X阵营
local battleStartCampHandle = function ( card, goalCard )
	-- body
	print("-----------battleStartCampHandle---------")
	-- local data = DPF:copytable(card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_BATTLE_START_CAMP));
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_BATTLE_START_CAMP);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);			
			if next(goalCard) ~= nil then
				local count = 0;
				local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);
				for i,j in pairs(goalCard) do
					-- local _factionId = get_st_bcardinfo_value(j:getMatchCardData():getCID(), "faction");
					-- print("=====================ss",_factionId)
					-- if _factionId == v.conditionparam then
					-- 	count = count + 1;
					-- 	print("countcount",count)
					-- end
					for i1,j1 in pairs(j) do
						if i1 == "m_pMatchCardForm" then
							local _factionId = get_st_bcardinfo_value(j1:getCID(), "faction");
							if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
								count = count + 1;
							end
						end
					end
				end
				v.effmainparam = v.effmainparam * count;
			end
			onEffect(card, v ,goalCard);
		end
	end
end

--上场时·全场每有1名特定阵营
local startCampAllHandle = function ( card, goalCard )
	-- body
	print("-----------startCampAllHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_START_CAMP_ALL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);			
			if next(goalCard) ~= nil then
				local count = 0;
				local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);
				for i,j in pairs(goalCard) do
					if j:getMatchCardData():getIsVaild() == true then
						--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
						local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
						local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

						if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
							count = count + 1;
						end
					end
				end
				v.effmainparam = v.effmainparam * count;
			end
			onEffect(card, v ,goalCard);
		end
	end
end

--死亡时阵营判断
local deadCampJudgeHandle = function ( card, goalCard )
	-- body
	print("-----------deadCampJudgeHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_DEAD_CAMP_JUDGE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
			local cardInfoCid = get_st_cardindex_value(goalCard.m_pMatchCardForm:getUniqueid(), "cid")						
			local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);

			if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);		
				onEffect(card, v);
			end
		end
	end
end

--攻击时，全场存在特定阵营角色个数
local attackCampAll = function ( card, goalCard )
	-- body
	print("-----------attackCampAll---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATTACK_CAMP_ALL);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);			
			local count = 0;
			if next(goalCard) ~= nil then
				local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);
				for i,j in pairs(goalCard) do
					if j:getMatchCardData():getIsVaild() == true then
						--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
						local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
						local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

						if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
							count = count + 1;
						end
					end
				end
			end
			v.effmainparam = v.effmainparam * count;
			onEffect(card, v ,goalCard);
		end
	end
end

--攻击时，全场若存在特定阵营角色
local attackCampOne = function ( card, goalCard )
	-- body
	print("-----------attackCampOne---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATTACK_CAMP_ONE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);

			for i,j in pairs(goalCard) do
				if j:getMatchCardData():getIsVaild() == true then
					--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
					local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
					local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

					if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
						card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);	
						onEffect(card, v, j);
						break;
					end

				end
			end
		end
	end
end

--受到特定阵营攻击时
local attackedCampHandle = function ( card, goalCard )
	-- body
	print("-----------attackedCampHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATTACKED_CAMP);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);

			for i,j in pairs(goalCard) do
				if j:getMatchCardData():getIsVaild() == true then
					--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
					local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
					local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

					if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
						card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);	
						onEffect(card, v, j);
						break;
					end
				end
			end
		end
	end
end

--特定角色施放能量技时
local powerSkillCampHandle = function ( card, goalCard )
	-- body
	print("-----------powerSkillCampHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL_CAMP);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);

			for i,j in pairs(goalCard) do
				if j:getMatchCardData():getIsVaild() == true then
					--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
					local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
					local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

					if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
						card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);	
						onEffect(card, v, j);
						break;
					end
				end
			end
		end
	end
end

--特定阵营同队角色施放能量技时
local powerSkillCampSelfHandle = function ( card, goalCard )
	-- body
	print("-----------powerSkillCampSelfHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL_CAMP_SELF);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);

			if goalCard:getMatchCardData():getIsVaild() == true then
				--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
				local cardInfoCid = get_st_cardindex_value(goalCard.m_pMatchCardForm:getUniqueid(), "cid")						
				local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

				if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
					card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);	
					onEffect(card, v, goalCard);
				end
			end
		end
	end
end

--上场时友方阵营判断
local battleStartCampJudgeHandle = function ( card, goalCard )
	-- body
	print("-----------battleStartCampJudgeHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_BATTLE_START_CAMP_JUDGE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);	
			-- 狂暴化单独处理下死亡清除，以前的写的不好改
			if v.effect == E_Effect.EE_MyTeamAura then
				local teamType = card:getMatchCardData():getTeam();
				MatchCtrl:getInstance():getMatchCardCtrl():registerCleanAnomaly(card:getMatchCardData():getSID(), E_Anomaly.EA_MyTeamAura, teamType);
			end

			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);
			for i,j in pairs(goalCard) do
				if j:getMatchCardData():getIsVaild() == true then
					--从图鉴表中用uid获取bcardinfo中所需的cid索引，可以避免此处判断是pve还是pvp。副本怪和玩家的英雄cid会不同，但uid是一样的。
					local cardInfoCid = get_st_cardindex_value(j.m_pMatchCardForm:getUniqueid(), "cid")						
					local _factionId = get_st_bcardinfo_value(cardInfoCid, "faction");

					if G_if_var_in(_factionId, condition1, condition2, condition3, condition4) then
						onEffect(card, v, j);
					end
				end
			end
		end
	end
end

--本方存活角色人数判断
local myTeamAlifeHandle = function ( card, goalCard )
	-- body
	print("-----------myTeamAlifeHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MYTEAM_ALIVE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local _aliveTable = {}
			local _resurgenceTable = {}
			for i,j in pairs(goalCard) do
				print("getIsTeamMember",j:getMatchCardData():getIsTeamMember())
				if j:getMatchCardData():getIsVaild() == true then
					table.insert(_aliveTable,j)
				else
					table.insert(_resurgenceTable,j)
				end
			end
			print("_aliveTable",#_aliveTable,"_resurgenceTable",#_resurgenceTable)
			if #_aliveTable < v.conditionparam then
				-- if then
				--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v, _resurgenceTable);
			end
		end
	end
end

--受到物理攻击被动
local physicsAttackedHandle = function ( card, goalCard )
	-- body
	print("-----------physicsAttackedHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_PHYSICS_ATTACKED);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

-- 队友受到致命伤害时
local FataldamageTeammateHandle = function ( card, goalCard )
	-- body
	print("-----------FataldamageTeammateHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE_TEAMMATE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			onEffect(card, v ,goalCard);
		end
	end
end

-- 目标所有异常状态和减益效果
local goalAnomalyAndDebuffHandle = function ( card, goalCard )
	-- body
	print("-----------goalAnomalyAndDebuffHandle---------")
	--条件满足，产生被动效果
	local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_ANOMALY_DEBUFF);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(goalCard, v, card);
		end
	end
end

-- 每次行动时，己方全体异常判断
local goalAnomalyMyTeamHandle = function ( card, goalCard )
	-- body
	print("-----------goalAnomalyMyTeamHandle---------")
		--条件满足，产生被动效果
		local data = goalCard.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GOAL_ANOMALY_MYTEAM);
		if next(data) ~= nil then
			for k, v in pairs(data) do
				if v.conditionparam == EFFECTTYPE.BEEN_HURT_ADD and card:getMatchCardData():getIsBeenHurtAdd() then
					--gv+7被动技能
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
				end
				if v.conditionparam == EFFECTTYPE.HURT_ADD and card:getMatchCardData():getIsBeenHurtAddAdd() then
					--光辉赛罗+11被动技能
					goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
					onEffect(goalCard, v);
					return
				end
				local anomalyID = MatchConditionCtrl:changeType(v.conditionparam)
				if card.m_pMatchAnomaly:isAnomalyByType(anomalyID) then
					-- if then
					--条件满足，产生被动效果
					if v.effect > E_Effect.EE_ProbabilityStopSkill or v.effect < E_Effect.EE_TreatmentSeal then
						goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
						onEffect(goalCard, v);
					else							
						-- if 闪避 then
						if card.m_iHitOrDodge ~= E_MATCH.HITORDODGE_DODGE then
							--[[ EE_ProbabilityGiddy  EE_ProbabilityChaos   EE_ProbabilityStopSkill   ]]
							goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
							onEffect(goalCard, v);
						else
							print("闪避，不触发被动！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！")
							if v.effect ~= E_Effect.EE_ProbabilityGiddy and v.effect ~= E_Effect.EE_ProbabilityChaos and v.effect ~= E_Effect.EE_ProbabilityStopSkill then
								goalCard.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
								onEffect(goalCard, v);
							end
						end
					end
				-- end
				end
			end
		end
end

--敌方死亡时触发
local deadEnemyHandle = function ( card, goalCard )
	-- body
	print("-----------deadEnemyHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_DEAD_ENEMY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--自身行动时以及受到主动技治疗时生命值判断（给自己加buff）
local myselfLifeTreatmentHandle = function ( card, goalCard )
	-- body
	print("-----------myselfLifeTreatmentHandle---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MYSELFLIFE_JUDGE_TREATMENT);
	local HPPercentage = (card:getMatchCardDataAdd():getHP() / card:getMatchCardData():getHPMax())*100;
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			if HPPercentage < v.conditionparam or v.conditionparam == 0 then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--持有指定异常的角色行动后
local judgeAnomaly = function ( card, goalCard )
	-- body
	print("-----------judgeAnomaly---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_JUDGE_ANOMALY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if goalCard:getMatchAnomaly():isAnomalyByType(v.conditionparam) then
			--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--自身能量数量判断，根据奇偶触发不同的效果
local selfPowerJudge = function ( card, goalCard )
	-- body
	print("-----------judgeAnomaly---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER_JUDGE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if card:getMatchCardData():getFury()%2 == v.conditionparam then
				--条件满足，产生被动效果
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--攻击时，检测敌方死亡人数，根据人数强化属性
local atkCheckEnemyLess = function ( card, goalCard )
	print("-----------atkCheckEnemyLess---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATK_CHECK_ENEMYLESS);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local teamType = card:getMatchCardData():getTeam();
			if teamType == E_MATCH.TEAM_MY then
				teamType = E_MATCH.TEAM_OPPO;
			else
				teamType = E_MATCH.TEAM_MY;
			end
			local enemyCount = E_MATCH.CONST_MEMBER_MAX - #(MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType));
			v.effmainparam = v.effmainparam * enemyCount;
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--受击时，检测敌方存活人数，根据人数强化属性
local atkCheckEnemyMore = function ( card, goalCard )
	print("-----------atkCheckEnemyMore---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATK_CHECK_ENEMYMORE);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local teamType = card:getMatchCardData():getTeam();
			if teamType == E_MATCH.TEAM_MY then
				teamType = E_MATCH.TEAM_OPPO;
			else
				teamType = E_MATCH.TEAM_MY;
			end
			local enemyCount = #(MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType));
			v.effmainparam = v.effmainparam * enemyCount;
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--受击且没有暴击时
local attackedNoCrit = function ( card, goalCard )
	-- body
	print("-----------attackedNoCrit---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATTACKED_NOCRIT);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

--受到物理类型的攻击（只检测主动技）
local getHurtPhysics = function ( card, goalCard )
	-- body
	print("-----------getHurtPhysics---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GETHURT_PHYSICS);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

--受到能量类型的攻击（只检测主动技）
local getHurtEnergy = function ( card, goalCard )
	-- body
	print("-----------getHurtEnergy---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_GETHURT_ENERGY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			-- if then
			--条件满足，产生被动效果
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v, goalCard);
		end
	end
end

-- 每回合行动时检测场上存活人数(必须有人死亡)
local stepStartAlive = function ( card, goalCard )
	print("-----------stepStartAlive---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_STEP_START_ALIVE);
	if next(data) ~= nil then
		local teamType = card:getMatchCardData():getTeam();
		local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
		local selfTeamLiveCards = matchCardCtrl:getVaildCardsByTeam(teamType);
		local selfTeamAllCards = matchCardCtrl:getTeam(teamType);
		local isHaveDead = false;
		for k,v in pairs(selfTeamAllCards) do
			if v:getMatchCardData():getIsTeamMember() == true and v:getMatchCardData():getIsLive() == false then
				isHaveDead = true;
				break;
			end
		end

		for k, v in pairs(data) do
			if #selfTeamLiveCards < v.conditionparam and isHaveDead then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

-- 能量技攻击时，检测自身持有的状态id
local atkCheckAnomaly = function ( card, goalCard )
	print("-----------atkCheckAnomaly---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ATK_CHECK_ANOMALY);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if card.m_pMatchAnomaly:isAnomalyByType(v.conditionparam) then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
				onEffect(card, v);
			end
		end
	end
end

--检测自身能量数,满足X点时,添加崩坏buf
local checkSelfEnergyNumber = function(card, goalCard)

	print("-----------checkSelfEnergyNumber---------")
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER_NUM);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			onEffect(card, v);
		end
	end
end

--第n次施放能量技时
local powerSkillXTimesHandle = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL_X_Times);
	for k, v in pairs(data) do
		if card:getMatchCardData():getEnergySkillCount() == v.conditionparam then
			onEffect(card, v, goalCard);
		end
	end
end

--行动成员数检测
local checkActionMemberCount = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ACTION_MEMBERS_COUNT)
	for k, v in pairs(data) do
		if v.effect == E_Effect.EE_Initiative then --触发主动技
			local matchStepMid = MatchCtrl:getInstance():getMatchStepMid()
			local _skillDatas = MatchSkill:getSkillDatas(v.effmainparam)
			matchStepMid:getMatchStepMidData():setIsApplyingSkill(true)
			matchStepMid:getMatchStepMidData():saveAtkDatas()
			matchStepMid:getMatchStepMidData():exchangeAtkDatas(card, _skillDatas)
			
			MatchLog:getInstance():nextAttack()
			MatchLog:getInstance():setCurrentAction("mainAction")
			MatchLog:getInstance():setLoop(MatchCtrl:getInstance():getMatchLoop():getLoopIndex())
			MatchLog:getInstance():setSkillID(v.effmainparam)
			MatchLog:getInstance():setCurrentEffect("effect1")
			MatchLog:getInstance():setCurrentCollection("attackCard")
			MatchLog:getInstance():locateCardMsgByIndexSole(card:getMatchCardData():getIndexSole())
			MatchLog:getInstance():setCurrentCollection("beforeAtk")
			
			matchStepMid:runEffect1()
		else --被动技能
			onEffect(card, v, goalCard)
		end
	end
end

--当前敌方在场人数
local checkCurrentOppotemMembers = function(card, goalCard)	
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_CURRENT_OPPOTEM_MEMBERS)
	local teamType = card:getMatchCardData():getTeam()
	local teamCards = MatchCtrl:getInstance():getMatchCardCtrl():getOppoTeam(teamType)
	local memberCards = MatchCtrl:getInstance():getMatchCardCtrl():getMemberCards(teamCards)
	if #memberCards	> 0 then
		for k, v in pairs(data) do
			local val1 = math.floor(v.conditionparam / 10)
			local val2 = math.ceil(v.conditionparam % 10)
			if #memberCards >= 1 and #memberCards < val1 then
				v.effmainparam = v.effmainparam + 1
			elseif #memberCards >= val1 and #memberCards <= val2 then
				
			elseif #memberCards > val2 then
				v.effmainparam = v.effmainparam - 1
			end
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v)
		end
	end
end

--暴击检测: 将此次攻击时主动技是否造成暴击而解析出来的触发技存起来给到atkcard
local checkAtkCardCrit = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_CHECK_CRIT);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v);
		end
	end
end

--首次被主动技攻击且未被暴击时
local targetMainskillCritFirstNo = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MAINSKILL_ATK_FIRST_CRIT_NO);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			if v.conditionparam == 0 then
				onEffect(card, v)
			elseif v.conditionparam == 1 then
				local teamType = card:getMatchCardData():getTeam()
				local cardlist = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
				for _, mCard in pairs(cardlist) do
					onEffect(mCard, v)
				end
			end
		end
	end
end

--首次被主动技攻击且被暴击时
local targetMainskillCritFirstYes = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MAINSKILL_ATK_FIRST_CRIT_YES);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			if v.conditionparam == 0 then
				onEffect(card, v)
			elseif v.conditionparam == 1 then
				local teamType = card:getMatchCardData():getTeam()
				local cardlist = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
				for _, mCard in pairs(cardlist) do
					onEffect(mCard, v)
				end
			end
		end
	end
end

--每次施放主动技时
local checkMainSkillAttack = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_MAINSKILL_ATTACK);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag);
			onEffect(card, v)
		end
	end
end

--由buff触发的条件执行
local checkBuffTrigger = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_CONDITION_BUFF_TRIGGER);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v)
		end
	end
end

--特定宇宙人角色施放能量技时
local powerSkillCampCosmicmanHandle = function (card, goalCard)
	local gCid = goalCard:getMatchCardData():getCID()
	local gFactionId = get_st_bcardinfo_value(gCid, "faction")
	local cid = card:getMatchCardData():getCID()
	local factionId = get_st_bcardinfo_value(cid, "faction")
	if gFactionId == E_MATCH.ROLE_CAMP_COSMICMAN and factionId == E_MATCH.ROLE_CAMP_COSMICMAN then --攻击卡和队友都是宇宙人
		local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL_CAMP_COSMICMAN)
		if data and #data > 0 then
			--检测是否被禁锢、眩晕、宝石化、放逐、冰冻
			if not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Giddy) and  --眩晕
				not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Gemize) and	--宝石化
				not card:getMatchAnomaly():checkImprison(1) and	--禁锢
				not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Exile) and	--放逐
				not card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_Frost) then --冰冻
				for k, v in pairs(data) do
					math.randomseed(tostring(os.time()):reverse():sub(1, 6))
					local randValue = math.random(1, 100)
					if randValue < v.conditionparam then
						card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
						onEffect(card, v, goalCard)
					end
				end
			end
		end
	end
end

--检查目标血量
local checkTargetHP = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_TARGET_HP_CHECK)
	if data and #data > 0 then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v, goalCard)
		end
	end
end

--在本次攻击即将结束时，额外再触发一个或多个主动技
local runTriggerskillExtension = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_TARGET_RUNTRIGGERSKILL_EXTENSION)
	if data and #data > 0 then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v, goalCard)
		end
	end
end

--本方宇宙人施放能量技检测或卡牌阵亡检测
local powerSkillCampCosmicOrCardsDieCheck = function (card, goalCard)	
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_COSMICMAN_POWERSKILL_OR_CARDSDIE_CHECK);
	if next(data) ~= nil then
		for k, v in pairs(data) do
			local cardCID = get_st_cardindex_value(goalCard.m_pMatchCardForm:getUniqueid(), "cid")
			local factionID = get_st_bcardinfo_value(cardCID, "faction");
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam);
			if G_if_var_in(factionID, condition1, condition2, condition3, condition4) then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
				onEffect(card, v)
			end
		end
	end
end

--己方场上阵营角色数量检测
local selfRoleCampCountCheckHandle = function (card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ROLE_CAMP_COUNT_CHECK)
	if next(data) ~= nil then
		local teamType = card:getMatchCardData():getTeam()
		local cardlist = MatchCtrl:getInstance():getMatchCardCtrl():getVaildCardsByTeam(teamType)
		for k,v in pairs(data) do
			local count = 0
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam)
			for _, pCard in pairs(cardlist) do
				local cardCid = pCard:getMatchCardData():getCID()
				local factionID = get_st_bcardinfo_value(cardCid, "faction")
				if G_if_var_in(factionID, condition1, condition2, condition3, condition4) then
					count = count + 1
				end
			end
			if count > 0 then
				v.effmainparam = v.effmainparam * count
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
				onEffect(card, v)
			end
		end
	end
end

--攻击卡角色施放能量技时，对其进行阵营检测,是否满足被攻击卡一方中相关条件的卡牌阵营，若满足，则被攻击一方的条件角色执行某个效果
local powerSkillCampOppoHandle = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_POWER_SKILL_CAMP_OPPO)
	if next(data) ~= nil then
		local cid = goalCard:getMatchCardData():getCID()
		local factionId = get_st_bcardinfo_value(cid, "faction")
		for k,v in pairs(data) do
			local condition1,condition2,condition3,condition4 = transformFaction(v.conditionparam)
			if G_if_var_in(factionId, condition1, condition2, condition3, condition4) then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
				onEffect(card, v)
			end
		end 
	end
end

--将要施放能量技时，检测自身能量数是否高于条件值
local powerNumIsHigherThanHandle = function(card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_SELF_POWER_HIGHER_THAN_NUM)
	if next(data) ~= nil then
		local fury = card:getMatchCardData():getFury()
		for k,v in pairs(data) do
			if fury > v.conditionparam then
				card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
				onEffect(card, v)
			end
		end
	end
end

--本次行动即将结束时
local stepWillFinishedSoonHandle = function (card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_STEP_WILL_FINISHED_SOON)
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v)
		end
	end
end

--每次角色行动过程开始时
local roleStepStartHandle = function (card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ROLE_STEP_START)
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v)
		end
	end
end

--角色即将开始施放主动技能时
local roleStepMidActionStartHandle = function (card, goalCard)
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_ROLE_ACTION_START)
	if next(data) ~= nil then
		for k, v in pairs(data) do
			card.m_pMatchCardSkill:reduceTimes(v.passiveid, v.flag)
			onEffect(card, v, goalCard)
		end
	end
end


local fun_Handles = {
	[1]  = XAttackHandle,					--前X次攻击(buff施加目标为攻击卡牌自身)
	[2]  = XAttackedHandle,					--前X次受击
	[3]  = attackedHandle,					--受到攻击时
	[4]  = powerAttackedHandle,				--受到能量攻击时
	[5]  = beenTreatmentHandle,				--受到治疗时
	[6]  = deadHandle,						--死亡后触发
	[7]  = killHandle,						--击杀后触发
	[8]  = evasionHandle,					--闪避触发
	[9]  = parryHandle,						--格挡触发
	[10] = powerSkillHandle,				--能量技时触发
	[11] = myselfLifeHandle,				--自身生命判断
	[12] = goalLifeHandle,					--目标生命判断
	[13] = goalLifeComHandle,				--目标生命比较
	[14] = goalPoisonedHandle,				--目标中毒状态
	[15] = goalFireHandle,					--目标灼烧状态
	[16] = goalGiddyHandle,					--目标眩晕状态
	[17] = goalChaosHandle,					--目标混乱状态
	[18] = goalStopSkillHandle,				--目标封技状态
	[19] = goalHavePSkillHandle,			--目标拥有技能
	[20] = goalPowerHandle,					--目标能量数量
	[21] = roundStartHandle,				--回合开始阶段
	[22] = allATTACKHandle,					--所有攻击时
	[23] = battleStartHandle,				--战斗开始时 
	[24] = XAttackHandleWithEffect1Target,	--前X次攻击(buff施加目标与释放技能的第一效果攻击目标相同)
	[25] = SpecialPowerSkillHandle,			--特殊能量技触发(释放第二段能量技时检测)
	[26] = XNorAttackHandle,				--前X次普通技攻击
	[27] = FataldamageHandle,				--受到致命伤害时
	[28] = allAnomalyHandle,				--全体异常状态
	[29] = critHandle,						--暴击时触发
	[30] = selfPowerHandle,					--自身每有一点能量（释放能量技时）
	[31] = selfPowerAttackHandle,			--自身每有一点能量（受到攻击技时）
	[32] = goalAnomalyHandle,				--目标异常状态
	[33] = XRoundHandle,					--第X回合
	[34] = goalEvasionHandle,				--目标闪避时
	[35] = goalParryHandle,					--目标格挡时
	[36] = XmyselfSpecialbuffHandle,		--自身特殊buff次数判断(满足次数后移除buff)
	[37] = NorAttackHandle,					--普通技攻击
	[38] = firstPowerAttackedHandle,		--每回合第1次受能量技攻击时
	[39] = battleStartCampHandle,			--战斗开始时·每有1名X阵营
	[40] = myTeamAlifeHandle,			    --本方存活角色人数判断
	[41] = physicsAttackedHandle,			--受到物理攻击时
	[42] = FataldamageTeammateHandle,		--队友受到致命伤害时
	[43] = startCampAllHandle,		        --上场时·全场每有1名特定阵营
	[44] = deadCampJudgeHandle,		        --死亡时阵营判断
	[45] = battleStartCampJudgeHandle,		--上场时友方阵营判断
	[46] = goalAnomalyAndDebuffHandle,		--目标所有异常状态和减益效果
	[47] = goalAnomalyMyTeamHandle,		    --每次行动时，己方全体异常判断
	[48] = attackCampAll,		            --攻击时，全场存在特定阵营角色个数
	[49] = attackCampOne,		            --攻击时，全场若存在特定阵营角色
	[50] = attackedCampHandle,		        --受到特定阵营攻击时
	[51] = powerSkillCampHandle,		    --特定角色施放能量技时
	[52] = afterFirstPowerAttackedHandle,	--每回合第1次受能量技攻击后
	[53] = deadEnemyHandle,	                --敌方死亡时触发
	[54] = myselfLifeTreatmentHandle,	    --自身行动时以及受到主动技治疗时生命值判断（给自己加buff）
	[55] = judgeAnomaly,	    			--持有指定异常的角色行动后
	[56] = selfPowerNorAttackHandle,	    --自身每有一点能量（普通技攻击时）
	[57] = selfPowerJudge,	    			--自身能量数量判断，根据奇偶触发不同的效果
	[58] = atkCheckEnemyLess,	    		--攻击时，检测敌方死亡人数，根据人数强化属性
	[59] = atkCheckEnemyMore,	    		--受击时，检测敌方存活人数，根据人数强化属性
	[60] = attackedNoCrit,	    			--受击且没有暴击时
	[61] = getHurtPhysics,	    			--受到物理类型的攻击（只检测主动技）
	[62] = getHurtEnergy,	    			--受到能量类型的攻击（只检测主动技）
	[63] = atkCheckAnomaly,	    			--能量技攻击时，检测自身持有的状态id
	[64] = stepStartAlive,	    			--每回合行动时检测场上存活人数
	[65] = powerSkillCampSelfHandle,	    --特定阵营同队角色施放能量技时
	[67] = checkSelfEnergyNumber, 			--检查自身能量数
	[68] = powerSkillXTimesHandle, 			--第n次施放能量技时
	[69] = checkActionMemberCount,			--检查当前战场行动的成员数
	[70] = checkCurrentOppotemMembers,		--检测当前战场上敌方人数
	[71] = checkAtkCardCrit,				--攻击卡暴击检测
	[72] = targetMainskillCritFirstNo,		--目标第一次受到主动技攻击但未被暴击
	[73] = targetMainskillCritFirstYes,		--目标第一次受到主动技攻击且被暴击
	[74] = checkMainSkillAttack,			--每次施放主动技时
	[75] = checkBuffTrigger,				--buff触发的条件执行
	[76] = myAnomalyHandle,				--本方异常状态
	[77] = oppoAnomalyHandle,				--敌方异常状态
	[78] = powerSkillCampCosmicmanHandle,	--特定宇宙人角色施放能量技时
	[79] = checkTargetHP,					--检查目标血量
	[80] = runTriggerskillExtension,		--攻击力最高的目标本次攻击结束时额外再执行N个触发技
	[81] = powerSkillCampCosmicOrCardsDieCheck,	 --本方宇宙人施放能量技检测或卡牌阵亡检测
	[82] = selfRoleCampCountCheckHandle,	 --己方场上阵营角色数量检测
	[83] = powerSkillCampOppoHandle,	 	--敌方角色施放能量技时，同队角色阵营类型检测
	[84] = powerNumIsHigherThanHandle, 		--将要施放能量技时，检测自身能量数是否高于条件值
	[85] = stepWillFinishedSoonHandle,		--本次行动即将结束时触发
	[86] = roleStepStartHandle,				--角色小回合开始行动时
	[87] = roleStepMidActionStartHandle,	--角色即将开始施放主动技能时
	
};

--产生条件被动技能效果
--[[当goalCard为nil时，card即为效果的接受者，可能为攻击者也可能是被攻击者；当goalCard不为nil时，card为被动技能触发者，goalCard为可能被被动技能影响的对象(可为多个)]]
function MatchConditionCtrl:skillsConditionHandle( card, condition, goalCard )
	--判断是否在播放战报
	require "match/match_log_director"
	if MatchLogDirector:getInstance() ~= nil then
		return;
	end
	--判断是否是在执行被动技能触发的主动技能，如果是就不检查所有被动技能，避免无限循环
	local matchStepMid = MatchCtrl:getInstance():getMatchStepMid();
	if matchStepMid ~= nil then
		local bIsApplyingSkill = matchStepMid:getMatchStepMidData():getIsApplyingSkill();
		local iCounterAttackType = matchStepMid:getMatchStepMidData():getCounterattackType();		
		local pskillConditions = {
			E_PSKILLCONDITIONS.EPC_DEAD, 
			E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE, 
			E_PSKILLCONDITIONS.EPC_DEAD_CAMP_JUDGE,
			E_PSKILLCONDITIONS.EPC_SELF_POWER_NUM
		}
		--绝对之心, 受到致命伤害后,反击和触发技都生效
		local bHaveCondition = G_if_var_in(condition, pskillConditions)
		local absoluteHeartData = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_AbsoluteHeart)
		if absoluteHeartData and #absoluteHeartData > 0 and
			((absoluteHeartData[1].mark == 0 and condition == E_PSKILLCONDITIONS.EPC_FATAL_DAMAGE) or
			(absoluteHeartData[1].mark == 1 and condition == E_PSKILLCONDITIONS.EPC_TARGET_HP_CHECK)) then
			bHaveCondition = true
		end
		
		--<愿之红玉>：敌方被动技能致死后触发的回血也要执行
		if card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_HopeOfRuby) and
			card:getMatchCardSkill():havePSkillID(980) and
			condition == E_PSKILLCONDITIONS.EPC_TARGET_HP_CHECK then
			bHaveCondition = true
		end
		
		if (not bHaveCondition) and (bIsApplyingSkill or iCounterAttackType == 2) then
			return
		end
	end
	--[[
	被动技能判定
	]]
	if fun_Handles[condition] then
		fun_Handles[condition](card, goalCard);
	end
end

--是否具有特定免疫功能
function MatchConditionCtrl:isHaveImmune( card, nType )
	-- body
	local bHave = false;
	local truthEnergy = card:getMatchCardData():getTruthEnergy()
	if nType == E_IMMUNE.EI_GiddyImmune then 
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_GiddyImmune) or 
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SpecialDefense) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_EvilTemptation) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_GiddyImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_TimeSpaceJump) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PowerZeda) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then
			bHave = true;
		end
		--真理能量值超过40时,具有免疫<眩晕>效果
		bHave = bHave or truthEnergy >= 40
		--新生代集结buff的施加者也拥有 免疫<眩晕> 效果
		bHave = bHave or card.m_pMatchAnomaly:checkNewRallyOfRebirthImmune()
		--<愿之红玉>储存的血量恢复值超过某限定值,则拥有此buff的角色免疫<眩晕> 效果
		bHave = bHave or card.m_pMatchAnomaly:checkHopeOfRubyImmune()
		--次元之力达到6层时,检验免疫效果
		bHave = bHave or card.m_pMatchAnomaly:checkDimensionForceImmune(true)
	elseif nType == E_IMMUNE.EI_ChaosImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_ChaosImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SpecialDefense) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_EvilTemptation) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_ChaosImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PowerMolde) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then
			bHave = true;
		elseif card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PhantomBeastSource) then
			--幻兽之源达到4层以上获得免疫混乱效果
			local anomalyData = card.m_pMatchAnomaly:getAnomalyByType(E_Anomaly.EA_PhantomBeastSource)
			bHave = anomalyData[1].mark >= 4
		end
	elseif nType == E_IMMUNE.EI_ReduceFuryImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_ReduceFuryImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_ReduceFuryImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then
			bHave = true;
		elseif card:getMatchAnomaly():isAnomalyByType(E_Anomaly.EA_TripleSpark) then
			local anomalyTripleSpark = card:getMatchAnomaly():getAnomalyByType(E_Anomaly.EA_TripleSpark)
			if anomalyTripleSpark and #anomalyTripleSpark > 0 then
				local indexSole = card:getMatchCardData():getIndexSole()
				local cid = card:getMatchCardData():getCID()
				if anomalyTripleSpark[1].mark == indexSole and anomalyTripleSpark[1].cid == cid then
					bHave = true
				end
			end
		end
	elseif nType == E_IMMUNE.EI_StopSkillImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_StopSkillImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SpecialDefense) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_StopSkillImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then
			bHave = true;
		end
	elseif nType == E_IMMUNE.EI_FireImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_FireImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_FireImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_FireAndPoisonImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then --  or card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Special)
			bHave = true;
		end
		bHave = bHave or truthEnergy >= 80
	elseif nType == E_IMMUNE.EI_PoisonImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PoisonImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_PoisonImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_FireAndPoisonImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then --  or card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Special)
			bHave = true;
		end
		bHave = bHave or truthEnergy >= 80
	elseif nType == E_IMMUNE.EI_PhysicalImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PhysicalImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_PhysicalImmune) then --  or card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Special)
			bHave = true;
		end
	elseif nType == E_IMMUNE.EI_SpecialImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SpecialImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_SpecialImmune) then --  or card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Special)
			bHave = true;
		end
	elseif nType == E_IMMUNE.EI_TreatmentSealImmune then
		if card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_TreatmentSealImmune) or
			card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_TreatmentSealImmune) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_SoulForm) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_PowerGina) or
			card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_BigDipper) then --  or card.m_pMatchAnomaly:isAnomalyByType(E_Anomaly.EA_Special)
			bHave = true;
		end
		bHave = bHave or truthEnergy > 0
	elseif nType == E_IMMUNE.EI_PowerSkillImmune then
		if card.m_pMatchCardSkill:havePSImmune(E_Effect.EE_PowerSkillImmune) then
			bHave = true;
		end			
	end
	
	return bHave;
end

--被动格挡处理
function MatchConditionCtrl:parryHandle( card, condition, goalCard )
	-- body
	--判断是否触发主动技能反击
	local data = card.m_pMatchCardSkill:paSkillJudge(E_PSKILLCONDITIONS.EPC_PARRY);
	local skill = -1;
	if next(data) ~= nil then
		for k, v in pairs(data) do
			if v.effect == E_Effect.EE_Initiative then
				skill = v.effmainparam;
				if skill == 0 then
					skill = -1;
				end
			else
				onEffect(card, v, goalCard);
			end
		end
	end

	return skill;
end

--随机选择某方的一个卡牌
function MatchConditionCtrl:getRandomCard(_card)
	local teamType = _card:getMatchCardData():getTeam();
	local matchCardCtrl = MatchCtrl:getInstance():getMatchCardCtrl();
	local team = matchCardCtrl:getTeam(teamType);
	local temp = {};
	for k, v in ipairs(team) do
		if v:getMatchCardData():getIndex() ~= _card:getMatchCardData():getIndex() then
			table.insert(temp, v);
		end
	end

	local validCards = matchCardCtrl:getVaildCards(temp);
	local count = #validCards;
	if count > 0 then
		math.randomseed(os.time());
		return validCards[math.random(1, count)];
	else
		return _card;
	end
end

function MatchConditionCtrl:changeType( _effectType )
	-- body
	-- 数值表没有E_Anomaly，所以按照EFFECTTYPE配表，这里需要转换一下   主要用于EPC_ALL_ANOMALY和EE_RemoveAnomaly和EPC_GOAL_ANOMALY_MYTEAM
	if _effectType == EFFECTTYPE.HURT then
		return -1
	elseif _effectType == EFFECTTYPE.POWER_REDUCE then
		return E_BUFFID.EBI_EnergyReduce
	elseif _effectType == EFFECTTYPE.POWER_ADD then
		return E_BUFFID.EBI_EnergyAdd
	elseif _effectType == EFFECTTYPE.GIDDY then
		return E_BUFFID.EBI_Giddy
	elseif _effectType == EFFECTTYPE.POISONED then
		return E_BUFFID.EBI_Poisoned
	elseif _effectType == EFFECTTYPE.FIRE then
		return E_BUFFID.EBI_Fire
	elseif _effectType == EFFECTTYPE.PARRY_ADD then
		return E_BUFFID.EBI_BlockRateAdd
	elseif _effectType == EFFECTTYPE.PARRY_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_BlockRateAddNotDispel
	elseif _effectType == EFFECTTYPE.DEFENSE then
		return E_BUFFID.EBI_Defense
	elseif _effectType == EFFECTTYPE.RECOVERHP then
		return E_BUFFID.EBI_HFSM
	elseif _effectType == EFFECTTYPE.STOPSKILL then
		return E_BUFFID.EBI_StopSkill
	elseif _effectType == EFFECTTYPE.FOLLOWUP then
		return -1
	elseif _effectType == EFFECTTYPE.CHAOS then
		return E_BUFFID.EBI_Chaos
	elseif _effectType == EFFECTTYPE.CRIT_ADD then
		return E_BUFFID.EBI_CritRateAdd
	elseif _effectType == EFFECTTYPE.CRIT_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_CritRateAddNotDispel
	elseif _effectType == EFFECTTYPE.HIT_ADD then
		return E_BUFFID.EBI_HitRateAdd
	elseif _effectType == EFFECTTYPE.HIT_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_HitRateAddNotDispel
	elseif _effectType == EFFECTTYPE.EVASION_ADD then
		return E_BUFFID.EBI_DodgeRateAdd
	elseif _effectType == EFFECTTYPE.EVASION_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_DodgeRateAddNotDispel
	elseif _effectType == EFFECTTYPE.RESILENCE_ADD then
		return E_BUFFID.EBI_AntiknockCritAdd
	elseif _effectType == EFFECTTYPE.EXPERTISE_ADD then
		return E_BUFFID.EBI_BrokenBlockRateAdd
	elseif _effectType == EFFECTTYPE.EXPERTISE_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_BrokenBlockRateAddNotDispel
	elseif _effectType == EFFECTTYPE.HURT_ADD then
		return E_BUFFID.EBI_AllDamageAdd
	elseif _effectType == EFFECTTYPE.SUCKHP then
		return E_BUFFID.EBI_xiXue
	elseif _effectType == EFFECTTYPE.STOPTREAT then
		return E_BUFFID.EBI_TreatmentSeal
	elseif _effectType == EFFECTTYPE.REMOVEANOMALY then
		return E_BUFFID.EBI_RelieveAnomaly
	elseif _effectType == EFFECTTYPE.HURT_REDUCE then
		return E_BUFFID.EBI_HURT_REDUCE
	elseif _effectType == EFFECTTYPE.HURT_RAISE then
		return E_BUFFID.EBI_HURT_RAISE
	elseif _effectType == EFFECTTYPE.HURT_RAISE_NOT_DISPEL then
		return E_BUFFID.EBI_RaiseHurtNotDispel
	elseif _effectType == EFFECTTYPE.CRITDAMAGE_ADD then
		return E_BUFFID.EBI_CritDamageAdd
	elseif _effectType == EFFECTTYPE.CRITDAMAGE_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_CritDamageAddNotDispel
	elseif _effectType == EFFECTTYPE.SPECIALDEFENSE then
		return E_BUFFID.EBI_SpecialDefense
	elseif _effectType == EFFECTTYPE.PERCENTFRIENDATK then
		return E_BUFFID.EBI_PercentFriendAtk
	elseif _effectType == EFFECTTYPE.PERCENTFRIENDPHYDEF then
		return E_BUFFID.EBI_PercentFriendPhyDef
	elseif _effectType == EFFECTTYPE.PERCENTFRIENDSPECDEF then
		return E_BUFFID.EBI_PercentFriendSpecDef
	elseif _effectType == EFFECTTYPE.DAMAGETRANSFER then
		return E_BUFFID.EBI_DamageTransfer
	elseif _effectType == EFFECTTYPE.DOLL then
		return E_BUFFID.EBI_Doll
	elseif _effectType == EFFECTTYPE.REMOVEDEBUFF then
		return E_BUFFID.EBI_RelieveDebuff
	elseif _effectType == EFFECTTYPE.PARAGGI then
		return E_BUFFID.EBI_Paraggi
	elseif _effectType == EFFECTTYPE.SPATIAL_REINFORCE then
		return E_BUFFID.EBI_SpatialReinforce
	elseif _effectType == EFFECTTYPE.SPATIAL_WARP then
		return E_BUFFID.EBI_SpatialWarp
	elseif _effectType == EFFECTTYPE.SPECIALBUFF then
		return E_BUFFID.EBI_SpecialBuff
	elseif _effectType == EFFECTTYPE.GLASS_SEAL then
		return E_BUFFID.EBI_GlassSeal
	elseif _effectType == EFFECTTYPE.REMOVEALLBUFF then
		return E_BUFFID.EBI_RemoveAllBuff
	elseif _effectType == EFFECTTYPE.ENDMARK then
		return E_BUFFID.EBI_EndMark
	elseif _effectType == EFFECTTYPE.TREATMENTADD then
		return E_BUFFID.EBI_TreatmentAdd
	elseif _effectType == EFFECTTYPE.PERCENTATK then
		return E_BUFFID.EBI_PercentAtk
	elseif _effectType == EFFECTTYPE.PHYSICALDEFADD then
		return E_BUFFID.EBI_PhysicalFreeAdd
	elseif _effectType == EFFECTTYPE.SPECIALDEFADD then
		return E_BUFFID.EBI_SpecialFreeAdd
	elseif _effectType == EFFECTTYPE.DATAIZE then
		return E_BUFFID.EBI_Dataize
	elseif _effectType == EFFECTTYPE.PERCENTPHYSICALDEF then
		return E_BUFFID.EBI_PercentPhysicalDef
	elseif _effectType == EFFECTTYPE.PERCENTSPECIALDEF then
		return E_BUFFID.EBI_PercentSpecialDef
	elseif _effectType == EFFECTTYPE.DOUBLE_DEF then
		return E_BUFFID.EBI_DoubleDefPer
	elseif _effectType == EFFECTTYPE.SOUL_IMMORTAL then
		return E_BUFFID.EBI_SoulImmortal
	elseif _effectType == EFFECTTYPE.HURT_ADD_NOT_DISPEL then
		return E_BUFFID.EBI_AllDamageAddNotDispel
	elseif _effectType == EFFECTTYPE.HURT_FREE_NOT_DISPEL then
		return E_BUFFID.EBI_DamageFreeAddNotDispel
	else
		return -1
	end
end
