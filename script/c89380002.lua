function c89380002.initial_effect(c)
    c:SetUniqueOnField(1,1,89380002)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c89380002.spcon)
    e1:SetCost(c89380002.spcost)
    e1:SetTarget(c89380002.target)
    e1:SetOperation(c89380002.operation)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCondition(c89380002.drcon)
    e2:SetCost(c89380002.drcost)
    e2:SetTarget(c89380002.target)
    e2:SetOperation(c89380002.drop)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetCondition(c89380002.spcono)
    c:RegisterEffect(e3)
end
function c89380002.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,89380009)
end
function c89380002.spcono(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_MZONE,0,nil,89380009)==0 
end
function c89380002.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c89380002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() end
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,nil,nil)
end
function c89380002.eqfilter(c)
    return c:IsCode(89380009) and c:IsFaceup()
end
function c89380002.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
    if Duel.IsExistingMatchingCard(c89380002.eqfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and Duel.SelectYesNo(tp,aux.Stringid(89380002,0)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c89380002.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
        if not (g and Duel.Equip(tp,c,g:GetFirst(),false)) then return end
        local e1=Effect.CreateEffect(g:GetFirst())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c89380002.eqlimit)
        c:RegisterEffect(e1)
    end
end
function c89380002.eqlimit(e,c)
    return e:GetOwner()==c
end
function c89380002.drcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsType(TYPE_EQUIP)
end
function c89380002.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c89380002.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end