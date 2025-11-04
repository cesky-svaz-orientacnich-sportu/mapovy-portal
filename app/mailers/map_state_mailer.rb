# -*- encoding : utf-8 -*-
class MapStateMailer < ActionMailer::Base
  default from: "\"Mapový portál\" <mapovyportal@ceskyorientak.cz>"

  def map_proposed(map)
    @map = map
    mail(to: map.authorized_cartographers.map(&:email), reply_to: map.created_by.email, subject: "Nový požadavek na evidenci mapy #{@map}")
  end

  def map_changed_after_request(map, region_was)
    @map = map
    @region_was = region_was
    mail(to: map.authorized_cartographers(region_was).map(&:email), reply_to: map.created_by.email, subject: "Doplněný požadavek na evidenci mapy #{@map}")
  end

  def map_approved(map)
    @map = map
    mail(to: map.created_by.email, reply_to: map.approved_by.email, subject: "Požadavek na evidenci mapy #{@map} přijat")
  end

  def map_rejected(map, comment)
    @map = map
    @comment = comment
    mail(to: map.created_by.email, reply_to: map.approved_by.email, subject: "Požadavek na evidenci mapy #{@map} vrácen k doplnění")
  end

  def map_completed(map)
    @map = map
    mail(to: map.authorized_cartographers.map(&:email), reply_to: map.completed_by.email, subject: "Doplněny údaje k mapě #{@map}")
  end

  def map_completion_rejected(map, comment)
    @map = map
    @comment = comment
    mail(to: map.created_by.email, reply_to: map.approved_by.email, subject: "Požadavek na schválení mapy #{@map} vrácen k doplnění")
  end

  def reminder_on_proposed(map)
    return if map.last_reminder_sent_at == Date.today
    return unless map.state == Map::STATE_PROPOSED
    @map = map
    map.update_attribute :last_reminder_sent_at, Date.today
    mail(to: map.authorized_cartographers.map(&:email), subject: "Připomínka -- čekající požadavek na evidenci mapy #{@map}")
  end

  def reminder_before_completed(map)
    return if map.last_reminder_sent_at == Date.today
    return unless map.state == Map::STATE_APPROVED
    @map = map
    map.update_attribute :last_reminder_sent_at, Date.today
    mail(to: map.created_by.email, subject: "Připomínka -- je potřeba doplnit údaje k mapě #{@map} po závodě")
  end

  def reminder_on_requested_change(map)
    return if map.last_reminder_sent_at == Date.today
    return unless map.state == Map::STATE_CHANGE_REQUESTED or map.state == Map::STATE_FINAL_CHANGE_REQUESTED
    @map = map
    map.update_attribute :last_reminder_sent_at, Date.today
    mail(to: map.created_by.email, subject: "Připomínka -- je potřeba doplnit údaje k mapě #{@map}")
  end

end
