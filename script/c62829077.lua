--Scripted by Eerie Code
--Shining Hope Road
function c62829077.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCost(c62829077.cost)
	e1:SetTarget(c62829077.target)
	e1:SetOperation(c62829077.activate)
	c:RegisterEffect(e1)
end

function c62829077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62829077.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c62829077.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler()==e:GetHandler()
end

function c62829077.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62829077.xyzfilter(c,mg)
	if c.xyz_count~=3 or not c:IsSetCard(0x7f) or mg:GetCount()==0 then return false end
	if c:IsCode(52653092) then
		local mc=mg:GetFirst()
		local rk=mc:GetRank()
		if rk==0 or not mc:IsSetCard(0x48) then return false end
		mc=mg:GetNext()
		while mc do
			if rk~=mc:GetRank() or not mc:IsSetCard(0x48) then return false end
			mc=mg:GetNext()
		end
		return true
	else
		return c:IsXyzSummonable(mg)
	end
end
function c62829077.mfilter1(c,exg)
	return exg:IsExists(c62829077.mfilter2,1,nil,c)
end
function c62829077.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c62829077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c62829077.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,3)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and mg:GetCount()>2
		and Duel.IsExistingMatchingCard(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c62829077.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	local exg2=exg:Filter(c62829077.mfilter2,nil,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c62829077.mfilter1,2,2,tc1,exg2)
	sg1:Merge(sg2)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,3,0,0)
end
function c62829077.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62829077.activate(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message("Beginning operations...")
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then 
		--Debug.Message("Not enough locations.")
		return 
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	--Debug.Message("There are " .. g:GetCount() .. " cards.")
	g=g:Filter(c62829077.filter2,nil,e,tp)
	--Debug.Message("There are " .. g:GetCount() .. " cards.")
	if g:GetCount()<3 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	local tc3=g:GetNext()
	Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonStep(tc3,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	local e2=e1:Clone()
	tc2:RegisterEffect(e2)
	local e0=e1:Clone()
	tc3:RegisterEffect(e0)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DISABLE_EFFECT)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e3)
	local e4=e3:Clone()
	tc2:RegisterEffect(e4)
	local e5=e3:Clone()
	tc3:RegisterEffect(e5)
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
